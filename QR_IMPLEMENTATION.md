# QR-Based Account Sharing Implementation

## Overview
We've implemented a QR-based account sharing system for Khata that allows users to share their accounts with up to 5 members using QR codes.

## Key Features

### 1. QR Code Generation
- Users can generate QR codes to share their account
- QR codes expire after 10 minutes for security
- Contains invitation data with owner information

### 2. QR Code Scanning
- Users can scan QR codes to join shared accounts
- Built-in camera scanner with flash support
- Error handling for invalid or expired codes

### 3. Member Management
- View up to 5 members in the account
- Remove members directly from the settings
- Real-time member list updates

### 4. Embedded in Settings
- No separate screens needed
- QR functionality is embedded in the settings screen
- Uses dialogs for QR generation and scanning

## Files Modified/Created

### New Services
- `lib/services/member_sharing_service.dart` - Core sharing logic

### Updated Widgets
- `lib/features/settings/widgets/khata_sync_card.dart` - Enhanced with QR functionality

### Firestore Configuration
- `firestore.rules` - Security rules for sharing data
- `firestore.indexes.json` - Optimized database indexes
- `firebase.json` - Updated configuration

### Dependencies Added
- `qr_flutter: ^4.1.0` - QR code generation
- `mobile_scanner: ^5.0.0` - QR code scanning

## Firestore Collections

### 1. sharing_invitations
- Temporary documents for QR code sharing
- Auto-expires after 10 minutes
- Contains owner information and invitation ID

### 2. shared_accounts/{ownerUid}/members
- Stores member information for each account owner
- Limited to 5 members per account
- Includes member details and join date

### 3. member_accounts
- Reverse mapping for members to find their account owner
- Allows members to leave shared accounts

## Security Rules
- Users can only access their own data
- Members can access shared account transactions
- Invitation system prevents unauthorized access
- Time-based expiration for security

## Usage

### To Share Account:
1. Sign in with Google
2. In Settings, click "Share QR" in the Account Sharing section
3. Show generated QR code to person you want to invite
4. QR code expires in 10 minutes

### To Join Account:
1. Sign in with Google
2. In Settings, click "Scan QR" in the Account Sharing section
3. Scan the QR code shared by account owner
4. Automatically joins the shared account

### To Manage Members:
1. View member list in the Account Sharing section
2. Click red remove button to remove members
3. Member list updates in real-time

## Deployment Steps

1. Install dependencies: `flutter pub get`
2. Deploy Firestore rules: `firebase deploy --only firestore:rules`
3. Deploy Firestore indexes: `firebase deploy --only firestore:indexes`
4. Build and deploy the app

## Error Handling
- Invalid QR codes show appropriate error messages
- Expired invitations are handled gracefully
- Network errors are caught and displayed
- Camera permissions are requested when needed

The implementation is complete and ready for testing!
