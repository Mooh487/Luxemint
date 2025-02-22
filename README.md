# Luxemint

## Overview
Luxemint is a Clarity-based smart contract designed for issuing non-fungible tokens (NFTs) as loyalty signatures for customers who purchase luxury items. These NFTs can be used to claim rewards and discounts on future purchases.

## Features
- **Minting on Purchase**: NFTs are minted when a customer purchases a luxury item.
- **Non-Fungible Tokens**: Uses Clarity's `define-non-fungible-token` mechanism.
- **Loyalty Program Integration**: Customers can claim rewards and benefits using their NFTs.
- **Approval Mechanism**: Allows token holders to authorize other principals to transfer their NFTs.
- **Transfer Restriction**: The contract owner can enable or disable NFT transfers.
- **Secure Signature Verification**: Uses `secp256k1` for validating signatures.

## Contract Constants
- **Token Name**: `LuxuryNFT`
- **Token Symbol**: `LUXE`
- **Base URI**: Set as an empty string by default but can be used for metadata storage.

## Data Variables
- **contract-owner**: Stores the contract owner’s principal.
- **signer-public-key**: Stores the public key used for verifying claims.
- **last-token-id**: Tracks the last minted NFT ID.
- **transferrable**: Boolean flag indicating if NFTs can be transferred.

## Data Maps
- **nft-approvals**: Maps NFT IDs to approved transfer principals.
- **minted-verify-ids**: Tracks whether a verification ID has been used for minting.
- **campaign-minted**: Tracks the number of NFTs minted for each campaign.
- **nft-cids**: Maps NFT IDs to campaign IDs.

## Public Functions
### Transfer
```clarity
(define-public (transfer (token-id uint) (owner principal) (recipient principal))
```
Transfers an NFT if the sender is the owner or an approved principal.

### Set Approval
```clarity
(define-public (set-approval-for (token-id uint) (approval principal))
```
Allows an approved principal to transfer a specified NFT.

### Claim NFT
```clarity
(define-public (claim (cid uint) (verify-id uint) (cap uint) (owner principal) (signature (buff 65)))
```
Mints an NFT for a customer after verifying the claim conditions.

### Update Transferability
```clarity
(define-public (update-transfferable (new-transferrable bool))
```
Enables or disables NFT transfers.

### Update Contract Owner
```clarity
(define-public (update-owner (new-owner principal))
```
Transfers contract ownership to a new principal.

### Update Signer Public Key
```clarity
(define-public (update-signer-public-key (new-public-key (buff 33)))
```
Updates the public key used for signature verification.

## Read-Only Functions
- **get-last-token-id**: Returns the last minted token ID.
- **get-token-uri**: Returns the metadata URI for a given token.
- **name**: Returns the token name (`LuxuryNFT`).
- **symbol**: Returns the token symbol (`LUXE`).
- **get-transferrable**: Returns whether NFT transfers are allowed.
- **get-owner**: Returns the owner of a given token.
- **get-approval**: Returns the approval principal for a token.
- **get-signer-public-key**: Returns the stored public key.
- **get-cid**: Returns the campaign ID for a token.
- **get-campaign-minted**: Returns the number of NFTs minted for a campaign.
- **is-verify-id-minted**: Checks if a verification ID has been used.
- **get-contract-hash**: Returns the contract hash.

## Private Functions
- **contract-hash**: Computes the contract hash.
- **is-owner**: Checks if a principal owns an NFT.
- **is-approval**: Checks if a principal is approved for a token.
- **is-owner-or-approval**: Checks if a principal is either the owner or an approved transfer agent.
- **clear-approval**: Clears the approval for a given token.
- **get-minted**: Gets the number of NFTs minted for a campaign.
- **is-minted**: Checks if a verification ID has been used.
- **under-cap**: Verifies if a campaign minting is under its cap.
- **valid-signature**: Verifies the validity of a signature.
- **hash-claim-msg**: Generates a hash for a claim message.
- **nft-uri**: Constructs the URI for an NFT’s metadata.

## Error Codes
- **`u100`**: Only the contract owner can perform the action.
- **`u101`**: Caller is not the token owner.
- **`u102`**: Invalid signature.
- **`u103`**: Minting cap reached.
- **`u104`**: Invalid signer public key.
- **`u105`**: NFTs are non-transferable.
- **`u106`**: Invalid address.
- **`u107`**: No approval exists for the token.

## Deployment and Usage
1. **Deploy the contract** to the Stacks blockchain.
2. **Mint an NFT** when a luxury item is purchased.
3. **Verify claims** using secure signature verification.
4. **Allow approved transfers** if necessary.

## Security Considerations
- **Signature Validation**: Ensures only authorized claims are minted.
- **Transfer Restriction**: Allows control over NFT movement.
- **Contract Ownership**: Enables ownership transfer and updates.

## Conclusion
LuxuryNFT is a robust NFT-based loyalty system tailored for luxury brands, providing customers with unique digital assets linked to their purchases.

