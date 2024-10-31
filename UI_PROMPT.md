# Password Manager UI Implementation Prompt

## Overview
Create a modern, secure password manager interface using Flutter that works across desktop (Windows/Linux) and mobile (Android) platforms. The application should follow Material Design principles while maintaining platform-specific UI patterns where appropriate.

## Design System

### Color Palette

#### Light Theme
- Background: #F5F5F5 (Light gray backdrop)
- Primary Elements: #2196F3 (Interactive elements, CTAs)
- Secondary Elements: #424242 (Text, icons)
- Accent: #FFC107 (Highlights, warnings)
- Success: #4CAF50 (Success states)
- Error: #F44336 (Error states)

#### Dark Theme
- Background: #121212 (Dark backdrop)
- Primary Elements: #2196F3 (Maintaining consistency with light theme)
- Secondary Elements: #EEEEEE (Text, icons)
- Accent: #FFC107 (Maintaining consistency with light theme)
- Success: #4CAF50 (Success states)
- Error: #F44336 (Error states)

### Typography
- Font Family: Roboto
- Scale:
  - H1: 24sp (Bold)
  - H2: 20sp (Medium)
  - H3: 18sp (Medium)
  - Body: 16sp (Regular)
  - Caption: 14sp (Regular)
  - Small: 12sp (Regular)

## Core Screens

### 1. Master Password Screen
- Clean, centered layout
- Master password input field with visibility toggle
- Clear error messaging
- "Unlock" primary button
- Optional biometric authentication button
- App logo/branding

### 2. Password Vault (Main Screen)
- Search bar at top
- Category/tag filtering system
- Password entry list with:
  - Website/app name
  - Username preview
  - Last modified date
  - Category indicator
  - Quick-copy buttons
- FAB for adding new entries
- Navigation drawer/menu for settings and additional options

### 3. Password Entry Detail
- Full-screen dialog/page
- Fields:
  - Title
  - Username/email
  - Password (masked with show/hide)
  - Website URL
  - Notes
  - Category selection
  - Tags
  - Last modified date
- Quick copy buttons for credentials
- Password strength indicator
- Edit/Delete options
- Password history access

### 4. Password Generator
- Length slider (8-64 characters)
- Character type toggles:
  - Uppercase letters
  - Lowercase letters
  - Numbers
  - Special characters
- Generated password display
- Strength indicator
- Copy button
- Regenerate button
- Save/Use button

### 5. Settings Screen
- Theme selection (Light/Dark/System)
- Auto-lock timeout
- Clipboard clear timeout
- Export/Import options
- Backup settings
- Security settings
- About section

## Platform-Specific Considerations

### Desktop (Windows/Linux)
- Sidebar navigation instead of bottom nav
- Keyboard shortcuts
- Multi-column layouts for larger screens
- Context menus
- Drag-and-drop support

### Mobile (Android)
- Bottom navigation
- FAB for new entries
- Pull-to-refresh
- Swipe actions on list items
- Modal bottom sheets for quick actions

## Interactive Elements

### Common Components
1. Password Entry Card
   - Consistent padding (16dp)
   - Clear hierarchy of information
   - Quick action buttons
   - Hover/press states

2. Action Buttons
   - Clear iconography
   - Tooltips on hover (desktop)
   - Appropriate touch targets (min 48x48dp)

3. Input Fields
   - Clear labels
   - Helper text
   - Error states
   - Character counters where appropriate

4. Dialog Boxes
   - Clear headers
   - Action buttons aligned to bottom
   - Appropriate padding
   - Backdrop blur/dim

## Accessibility Requirements
- Minimum touch target size: 48x48dp
- WCAG 2.1 compliant contrast ratios
- Screen reader support
- Keyboard navigation support
- Scalable text support
- Clear focus indicators

## Animation Guidelines
- Use Material Design motion patterns
- Keep animations subtle and purposeful
- Duration: 200-300ms for most transitions
- Ensure animations can be disabled

## Error Handling
- Clear error messages
- Non-blocking error displays
- Recovery actions where appropriate
- Offline support messaging

## Loading States
- Skeleton screens for initial loads
- Progress indicators for operations
- Shimmer effects for loading states
- Cancel options for long operations

## Additional Notes
- Ensure all interactive elements have appropriate feedback
- Maintain consistent spacing (8dp grid)
- Use elevation and shadows purposefully
- Implement responsive layouts
- Support both portrait and landscape orientations
- Consider different screen sizes and densities 