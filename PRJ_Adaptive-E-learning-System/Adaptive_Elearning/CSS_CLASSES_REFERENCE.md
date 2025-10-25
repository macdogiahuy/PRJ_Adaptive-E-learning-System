# 🎨 CART CSS CLASSES - QUICK REFERENCE

## Layout Classes

### Container
```css
.cart-main              /* Main wrapper with gradient background */
.container              /* Content container with max-width */
.cart-content           /* Grid layout for items + summary */
```

### Sections
```css
.cart-header            /* Page header section */
.cart-items-section     /* Items list container */
.cart-summary           /* Sticky sidebar summary */
```

## Typography

### Headings
```css
.cart-title             /* Main page title with icon */
.cart-subtitle          /* Subtitle text */
.cart-items-header h3   /* Section heading */
.cart-item-title        /* Individual item title */
```

## Card Components

### Cart Item
```css
.cart-item              /* Main item card */
.cart-item-image        /* Image container (180x120) */
.cart-item-info         /* Info section with title, instructor */
.cart-item-price        /* Price display section */
.cart-item-actions      /* Action buttons container */
```

### Item Details
```css
.cart-item-instructor   /* Instructor info with icon */
.cart-item-meta         /* Meta information container */
.meta-badge             /* Level/category badge */
```

## Price Components

```css
.original-price         /* Strikethrough original price */
.final-price            /* Large bold final price (gradient) */
.discount-badge         /* Discount percentage badge */
.total-amount           /* Large total in summary (gradient) */
```

## Button Classes

### Primary Buttons
```css
.btn-primary            /* Blue gradient button */
.btn-checkout           /* Green checkout button */
.btn-continue-shopping  /* Outlined continue button */
.btn-clear-cart         /* Red outlined clear button */
.btn-remove             /* Small remove icon button */
```

### Button States
```css
.btn-primary:hover      /* Lift + shadow */
.btn-remove:hover       /* Rotate + color change */
.add-to-cart-btn.loading /* Loading state */
.add-to-cart-btn.added  /* Success state */
```

## Summary Components

```css
.summary-row            /* Row in summary (label + value) */
.summary-divider        /* Gradient divider line */
.summary-total          /* Total row (bold) */
.discount-amount        /* Green discount text */
```

## Trust & Payment

```css
.trust-badges           /* Container for trust indicators */
.trust-badge            /* Single trust badge with icon */
.payment-methods        /* Payment methods container */
.payment-title          /* Payment section title */
.payment-icons          /* Icons container */
```

## Empty State

```css
.empty-cart             /* Empty cart container */
.empty-cart-icon        /* Large cart icon */
```

## Notification

```css
.toast                  /* Toast notification */
.toast.show             /* Visible state */
.toast.success          /* Success styling */
.toast.error            /* Error styling */
.toast.info             /* Info styling */
```

## Badge & Icons

```css
.cart-badge             /* Notification badge in header */
.discount-badge         /* Discount % badge */
.meta-badge             /* Level/info badge */
```

## Responsive Classes

### Mobile Adjustments (< 768px)
- Cart items use 2-row grid
- Image size: 120x80px
- Stacked price and actions
- Full-width buttons

### Tablet (768px - 1024px)
- Single column layout
- Summary below items
- Full width maintained

## Animation Classes

```css
/* Applied automatically: */
fadeIn                  /* General fade in */
fadeInDown              /* Slide down with fade */
fadeInUp                /* Slide up with fade */
slideInRight            /* Slide from right */
bounce                  /* Bouncing animation */
pulse                   /* Pulsing effect */
popIn                   /* Scale pop animation */
```

## Utility Classes

### Display
```css
.loading                /* Shows spinner, disables interaction */
.added                  /* Success state for buttons */
.show                   /* Makes toast visible */
```

## CSS Variables Reference

```css
/* Colors */
var(--primary-color)    /* #6366f1 */
var(--primary-dark)     /* #4f46e5 */
var(--success-color)    /* #10b981 */
var(--danger-color)     /* #ef4444 */
var(--text-primary)     /* #111827 */
var(--text-secondary)   /* #6b7280 */

/* Shadows */
var(--shadow-sm)        /* Small shadow */
var(--shadow-md)        /* Medium shadow */
var(--shadow-lg)        /* Large shadow */
var(--shadow-xl)        /* Extra large shadow */

/* Border Radius */
var(--radius-sm)        /* 0.375rem */
var(--radius-md)        /* 0.5rem */
var(--radius-lg)        /* 0.75rem */
var(--radius-xl)        /* 1rem */

/* Transition */
var(--transition)       /* all 0.3s cubic-bezier(...) */
```

## Common Patterns

### Card with Hover Effect
```html
<div class="cart-item">
  <!-- Hover: slides right, shows left border -->
</div>
```

### Gradient Text
```html
<span class="final-price">20,000 đ</span>
<!-- Uses gradient background-clip technique -->
```

### Icon Button with Animation
```html
<button class="btn-remove">
  <i class="fas fa-times"></i>
  <!-- Hover: rotates 90deg, changes color -->
</button>
```

### Badge with Icon
```html
<span class="meta-badge">
  <i class="fas fa-signal"></i>
  Beginner
</span>
```

## Browser Compatibility Notes

- **Backdrop-filter**: Not supported in Firefox < 103
- **CSS Grid**: Fully supported in modern browsers
- **CSS Variables**: Full support
- **Gradient text**: Works with -webkit prefix
- **Transforms**: Hardware accelerated

## Performance Tips

1. Use `transform` instead of `left/top` for animations
2. Avoid animating `width/height` - use `scale` instead
3. Use `will-change` sparingly
4. Leverage CSS variables for theming
5. Combine animations where possible

## Accessibility

- All buttons have hover/focus states
- Focus outlines: 3px solid with offset
- Color contrast meets WCAG AA
- Touch targets: minimum 44x44px
- Semantic HTML structure

---

**Last Updated:** 2024-10-25
