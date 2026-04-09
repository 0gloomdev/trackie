# Design System: Aura Learning (Trackie)
**Project Type:** Flutter Cross-platform Learning Management App

---

## 1. Visual Theme & Atmosphere

**Aesthetic:** "Cosmic Nebula" - A deep, immersive dark theme with ethereal glassmorphism and neon glow accents that evoke a futuristic, celestial learning environment.

**Mood:** Dense yet airy, with layered translucency creating depth without clutter. The interface feels like looking through frosted glass into a digital cosmos.

**Density:** Medium-high content density with generous whitespace between major sections, creating breathing room while maintaining information richness.

**Animation Philosophy:** Smooth, purposeful micro-interactions with 200-400ms transitions. Elements gently fade and slide into place, reinforcing the premium, polished feel.

---

## 2. Color Palette & Roles

### Primary Palette (Cosmic Purple)
| Name | Hex Code | Role |
|------|----------|------|
| **Luminous Lavender** | `#d3bfff` | Primary actions, key highlights, progress indicators |
| **Deep Violet** | `#c4abff` | Primary container backgrounds, hover states |
| **Royal Purple** | `#ba9eff` | Gradients, subtle accents |
| **Midnight Plum** | `#391b77` | On-primary text, dark mode foundations |

### Secondary Palette (Electric Cyan)
| Name | Hex Code | Role |
|------|----------|------|
| **Neon Cyan** | `#5ce6ff` | Secondary actions, interactive elements, links |
| **Aqua Spark** | `#2fd9f4` | Secondary hover states, active indicators |
| **Ocean Teal** | `#00cbe5` | Gradients, glowing accents |
| **Dark Teal** | `#00363e` | On-secondary text, dark foundations |

### Tertiary Palette (Soft Rose)
| Name | Hex Code | Role |
|------|----------|------|
| **Blush Pink** | `#ffb5c8` | Accent highlights, achievements, celebrations |
| **Rose Quartz** | `#f0779d` | Tertiary containers, subtle warmth |
| **Magenta Glow** | `#f58fad` | Gradients, special calls-to-action |
| **Deep Rose** | `#5c1330` | On-tertiary text |

### Surface & Background (Deep Space)
| Name | Hex Code | Role |
|------|----------|------|
| **Void Black** | `#060e20` | Deepest background, footer areas |
| **Cosmic Navy** | `#0b1325` | Main surface, app background |
| **Nebula Dark** | `#171f32` | Card backgrounds, elevated surfaces |
| **Stellar Grey** | `#131b2e` | Container backgrounds, modals |
| **Galaxy Blue** | `#222a3d` | Higher elevation surfaces |
| **Deep Cloud** | `#2d3448` | Hover states, subtle highlights |

### Semantic Colors
| Name | Hex Code | Role |
|------|----------|------|
| **Success Green** | `#22C55E` | Completion states, positive feedback |
| **Error Coral** | `#ffb4ab` | Error states, destructive actions |

### Neon Accents (Glow Effects)
| Name | Alpha | Role |
|------|-------|------|
| **Purple Glow** | 30% opacity | Subtle purple shadows, focus rings |
| **Cyan Glow** | 30% opacity | Secondary glow effects |
| **Purple Halo** | 50% opacity | Strong glow, active states |
| **Cyan Halo** | 50% opacity | Strong secondary glow |

---

## 3. Typography Rules

### Font Families
- **Headlines:** Space Grotesk (geometric, modern, tech-forward)
- **Body:** Manrope (highly readable, contemporary sans-serif)
- **Labels:** Inter (clean, utilitarian, excellent for badges)

### Weight Usage
| Style | Font | Weight | Size | Letter Spacing |
|-------|------|--------|------|----------------|
| Hero Title | Space Grotesk | 700 | 48px | -1.5px |
| Page Title | Space Grotesk | 700 | 40px | -1.0px |
| Section Title | Space Grotesk | 700 | 24px | -0.5px |
| Card Title | Space Grotesk | 600 | 18px | -0.2px |
| Stat Value | Space Grotesk | 700 | 32px | -1.0px |
| Subtitle | Manrope | 500 | 16px | 0 |
| Body | Manrope | 400 | 14px | 0.25px |
| Body Small | Manrope | 400 | 12px | 0.4px |
| Label | Inter | 500 | 14px | 0.1px |
| Type Badge | Inter | 700 | 10px | 1.0px (ALL CAPS) |

---

## 4. Component Stylings

### Glass Components (Frosted Glass Effect)
- **Blur Sigma:** 25.0 (heavy frosted blur for premium feel)
- **Background:** `rgba(23, 31, 50, 0.7)` - semi-transparent navy
- **Border:** 1.5px, `rgba(255, 255, 255, 0.1)` - subtle light edge
- **Corner Radius:** 12px standard, 20px for cards, 32px for hero sections
- **Glow on Hover:** Primary or secondary color at 30% opacity, 15px blur

### Buttons
| Style | Background | Border | Corner Radius | Height |
|-------|------------|--------|----------------|--------|
| Primary | Purple 26% → 51% on hover | Purple 128% → 100% | 12px | 48px |
| Secondary | White 26% → 51% on hover | White 51% | 12px | 48px |
| Outline | Transparent | White 26% | 12px | 48px |
| Ghost | Transparent | None | 12px | 48px |

**Behavior:** On hover, a soft glow shadow appears (15px blur, -5px spread). On press, background opacity increases.

### Cards/Containers (Shadcn Style)
- **Background:** `#171f32` (Cosmic Navy)
- **Corner Radius:** 20px standard, 32px for large cards
- **Border:** 1px `#1f2b49` (subtle edge definition)
- **Padding:** 24px standard, 32px for feature cards
- **Shadow:** Optional glow based on accent color
- **Hover Effect:** Border color intensifies, subtle glow appears

### Inputs/Forms
- **Background:** `#1f2b49`
- **Border:** 1px `#1f2b49`, on focus: `#d3bfff` (primary)
- **Corner Radius:** 12px
- **Placeholder Color:** `#94a3b8` (muted text)
- **Focus Ring:** 2px primary color with 30% opacity glow

### Icon Buttons
- **Shape:** Circle (48px) or Rounded Rectangle (12px radius)
- **Background:** Transparent → accent 51% on press
- **Border:** 1px white 51% → accent color on press
- **Glow:** 15px blur, accent color at 50% opacity on active

### Navigation (Bottom & Side)
- **Style:** Glassmorphism with 20px blur
- **Background:** `rgba(23, 31, 50, 0.8)`
- **Border Top:** 1px white 10% opacity
- **Active Indicator:** Primary color pill or dot with glow

---

## 5. Layout Principles

### Responsive Breakpoints
- **Mobile:** < 600px (single column, bottom navigation)
- **Tablet:** 600px - 1024px (adaptive grid, side rail)
- **Desktop:** ≥ 1024px (multi-column, persistent sidebar)

### Spacing System (8px Base Unit)
| Name | Value | Usage |
|------|-------|-------|
| xs | 4px | Tight spacing, icon gaps |
| sm | 8px | Related elements |
| md | 16px | Standard padding |
| lg | 24px | Section gaps |
| xl | 32px | Major section separators |
| 2xl | 48px | Page margins (desktop) |
| 3xl | 64px | Hero spacing |

### Card Grid
- **Mobile:** Single column, full width
- **Tablet:** 2 columns, 16px gap
- **Desktop:** 3-4 columns, 24px gap

### Content Width
- **Max Content:** 1440px centered
- **Sidebar Width:** 320px fixed (desktop)
- **Main Content:** Fluid, remaining space

### Alignment
- **Horizontal:** Left-aligned with consistent left padding
- **Vertical:** Top-to-bottom flow
- **Cards:** Consistent 24px internal padding

---

## 6. Animation Specifications

| Animation | Duration | Curve | Usage |
|-----------|----------|-------|-------|
| Fade In | 400ms | easeOut | Screen transitions |
| Slide Up | 300ms | easeInOut | Card appearances |
| Scale | 200ms | easeOut | Button press feedback |
| Glow Pulse | 1500ms | easeInOut (loop) | Active indicators |
| Tab Switch | 300ms | easeOut | Navigation transitions |

---

## 7. Design Tokens Summary

```css
/* Core Colors */
--color-primary: #d3bfff;
--color-secondary: #5ce6ff;
--color-tertiary: #ffb5c8;
--color-surface: #0b1325;
--color-surface-container: #171f32;
--color-on-surface: #dae2fc;

/* Glass Effect */
--glass-blur: 25px;
--glass-opacity: 0.7;
--glass-border: rgba(255, 255, 255, 0.1);

/* Typography */
--font-headline: 'Space Grotesk';
--font-body: 'Manrope';
--font-label: 'Inter';

/* Spacing */
--spacing-unit: 8px;
--radius-sm: 8px;
--radius-md: 12px;
--radius-lg: 20px;
--radius-xl: 32px;
```

---

## Usage Notes for Stitch

When prompting Stitch to generate new screens for Aura Learning:

1. **Use exact hex codes** from the color palette above
2. **Reference glassmorphism** with 25px blur and semi-transparent backgrounds
3. **Apply Space Grotesk** for headers, Manrope for body, Inter for labels
4. **Include neon glow** effects on interactive elements (15px blur, 30% opacity)
5. **Use 20px border radius** for cards, 12px for buttons
6. **Maintain dark theme** - all surfaces use deep navy/cosmic black tones

The design creates a premium, futuristic learning environment that feels both professional and approachable.