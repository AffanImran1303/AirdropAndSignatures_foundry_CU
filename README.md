# FOUNDRY - Airdrop and Signatures

## About the project:
A foundry Airdrop project using efficient data verification with Merkle Trees, alongside airdrop mechanics, signature verification, and scripting techniques.
Using Merkle Proofs to verify address eligibility, allowing to claim the airdrop token 'GNX'. Also, it implements signatures to ensure that only intended recipients can claim the tokens. And, generating scripts to create and deploy Merkle Trees, Merkle Proofs, and Root Hash.

## Merkle Trees:
A hierarchical data structure where its base consists of leaf nodes representing data that has been hashed. The top of the tree is the root hash, i.e. is created by hashing together pairs of adjacent nodes. This process continues until a single root hash at the top of the tree is generated. This ROOT HASH represents all the data in the tree.

## Merkle Proofs:
Verify that a specific piece of data is part of a Merkle Tree and consists of the hashes of sibling nodes (present at each level of the tree).

### MerkleAirdrop.sol -> cornerstone of this project
- constructor() takes an ERC20token and a MerkleRoot as parameters.
- A GENERATED_HASH_ROOT will be computed which will be compared to MerkleRoot (the one provided as parameter).
- Have a list of addresses of users who are eligible to airdrop (will be checked first).
- s_hasClaimed mapping of user's address who have already claimed the airdrop.
- Have claim(), takes claim amount and MerkleProof[], to check whether the claimer in the whitelist is allowed to claim or not. Once done, update the s_hasClaimed


### GNXToken.sol -> An ERC20 token used for airdrop in this project
- GenerateInput.s.sol -> Will create the input file
- MakeMerkle.s.sol -> Will generate the output file
- deployMerkleAirdrop.s.sol -> Script to deploy the GNXToken and MerkleAirdrop contracts.
- Interact.s.sol -> Script to handle the signing and claiming process, sign a message using an account that is included in Merkle Tree. The generated signature will allow another person to claim the airdrop on behalf of the original account.

### If GENERATED_HASH_ROOT == ROOT_HASH, then that original data is said to be part of the Merkle Tree.

- input.json -> contains our Merkle Tree Structure
- output.json -> contains the leaves, Merkle Proofs, and Root Hash that will be submitted to the test contract

## Third-party allowed to claim the tokens?
Yes, third-party individual(s) are allowed to execute and pay for the transactions(given that permission is granted) on the account holder's behalf. To achieve this, we will be using digital signatures.

### Digital Signatures -> 
1. The account creates a message (signed using their private key) stating that a third party can claim the tokens, which will provide UNIQUE SIGNATURE to grant permission.
2. When the claim() is called by third-party, the system verifies the signature
3. If a signature is both valid and the account is listed in Merkle Tree, the claim is processed, and airdrop tokens will be given to the account holder.

### Implementation of Signature Verification in MerkleAirdrop::claim()
- Begin, by adding a check at the start of the function to ensure the signature's validity.
- Next, implement the _isValidSignature(), taking a hashed message as input.
- Hashed message will contain an account and the amount to be claimed.
