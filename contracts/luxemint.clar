
;; title: LuxuryNFT
;; version: 0.1.0
;; summary: An NFT contract for luxury items that can be minted on purchase of a luxury item
;; description: This NFT will act as a Loyalty signature for our customers who purchase luxury items. The NFT will be minted on the purchase of a luxury item and will be used to claim rewards and discounts on future purchases.

(define-non-fungible-token luxurynfts uint)

;; constants
(define-constant token-name "LuxuryNFT")
(define-constant token-symbol "LUXE")
;; full uri: https://graphigo.prd.galaxy.eco/metadata/{contract_hash}/{nft_id}.json
(define-constant base-uri "")

;; errors
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-invalid-signature (err u102))
(define-constant err-cap-reached (err u103))
(define-constant err-invalid-signer-public-key (err u104))
(define-constant err-non-transferrable (err u105))
(define-constant err-invalid-address (err u106))
(define-constant err-not-approval (err u107))


;; data vars
;;
(define-data-var contract-owner principal tx-sender)
;; signer public key
(define-data-var signer-public-key (buff 33) 0x000000000000000000000000000000000000000000000000000000000000000000)
(define-data-var last-token-id uint u0)
;; transferrable
(define-data-var transferrable bool true)

;; data maps
;;
;; nft approvals<token-id, approval>
(define-map nft-approvals uint principal)
;; minted verify ids<verify-id, minted>
(define-map minted-verify-ids uint bool)
;; campaign minted<cid, minted>
(define-map campaign-minted uint uint)
;; nft cids<token-id, cid>
(define-map nft-cids uint uint)

;; public function
(define-public (transfer (token-id uint) (owner principal) (recipient principal))
    (begin
        (asserts! (var-get transferrable) err-non-transferrable)
        (asserts! (and (is-owner token-id owner) (is-owner-or-approval token-id tx-sender)) err-not-token-owner)
        (clear-approval token-id)
        (nft-transfer? luxurynfts token-id owner recipient)
    )
)
;; sets an approval principal - allowed to call transfer on owner behalf.
(define-public (set-approval-for (token-id uint) (approval principal))
    (begin
        (asserts! (is-owner token-id tx-sender) err-not-token-owner)
        (map-set nft-approvals token-id approval)
        (print {evt: "set-approval-for", token-id: token-id, approval: approval})
        (ok true)
    )
)

(define-public (claim (cid uint) (verify-id uint) (cap uint) (owner principal) (signature (buff 65))) 
    (begin
        (asserts! (is-standard owner) err-invalid-address)
        ;; check cap
        (asserts! (under-cap cid cap) err-cap-reached)
        ;; check verify id
        (asserts! (not (is-minted verify-id)) err-invalid-signature)
        ;; verify signature
        ;; (asserts! (valid-signature cid verify-id cap owner signature) err-invalid-signature)
        (let 
            (
                (token-id (+ (var-get last-token-id) u1))
                (minted-count (+ (get-minted cid) u1))
            )
            ;; increase cap
            (map-set campaign-minted cid minted-count)
            ;; save verify id
            (map-set minted-verify-ids verify-id true)
            ;; save nft cid
            (map-set nft-cids token-id cid)
            ;; save last token id
            (var-set last-token-id token-id)
            ;; mint token
            (try! (nft-mint? luxurynfts token-id owner))
            (print {evt: "claim", token-id: token-id, cid: cid, verify-id: verify-id, cap: cap, owner: owner})
            (ok token-id)
        )
    )
)

(define-public (update-transfferable (new-transferrable bool)) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
        (var-set transferrable new-transferrable)
        (print {evt: "update-transfferable", new-transferrable: new-transferrable})
        (ok true)
    )
)

(define-public (update-owner (new-owner principal)) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
        (asserts! (is-standard new-owner) err-invalid-address)
        (var-set contract-owner new-owner)
        (print {evt: "update-owner", new-owner: new-owner})
        (ok true)
    )
)

(define-public (update-signer-public-key (new-public-key (buff 33))) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
        (asserts! (not (is-eq new-public-key 0x000000000000000000000000000000000000000000000000000000000000000000)) err-invalid-signer-public-key)
        (var-set signer-public-key new-public-key)
        (print {evt: "update-signer-public-key", new-public-key: new-public-key})
        (ok true)
    )
)

