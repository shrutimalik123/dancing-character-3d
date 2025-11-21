# Dancing Character 3D Application

## Overview

This is a full-stack web application featuring an interactive 3D dancing character experience. The application combines React Three Fiber for 3D rendering with Express.js backend infrastructure. Users can view and interact with an animated 3D character that dances to music in a pink-themed environment with customizable appearance and multiple songs.

The application is built as a modern single-page application (SPA) with a clear separation between frontend and backend concerns, using TypeScript throughout for type safety.

## Features

**Animation System:**
- 5 distinct dance moves that cycle every 3 seconds: Spin & Bounce, Bounce & Twist, Side Sway, Wave Motion, and Jump & Rotate
- Smooth transitions between dance variations with immediate application to avoid stuttering
- Decoupled animation and audio states for reliability (animation works independently if audio fails)
- Frame-based animation using `useFrame` hook for 60 FPS performance


**Visual Effects:**
- Stage lighting system with 3 colored spotlights (pink, cyan, purple) that rotate around the character
- Particle system with 200 sparkles that float and twinkle in the scene
- Dynamic lighting effects synchronized with animation state
- Shadow casting and receiving for realistic depth

**User Controls:**
- "Shruti Start" button to begin dancing and music playback
- "Shruti Stop!" button to pause animation and reset music
- Status indicators showing playback state and audio loading status
- Error handling for browser autoplay policies with retry functionality

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture

**Technology Stack:**
- **React 18** with TypeScript for UI components
- **React Three Fiber** (@react-three/fiber) for 3D scene management
- **Three.js** as the underlying 3D graphics engine
- **@react-three/drei** for 3D utilities and helpers
- **@react-three/postprocessing** for visual effects
- **Vite** as the build tool and development server
- **TailwindCSS** for styling with a custom design system
- **Radix UI** components for accessible UI primitives

**Design Pattern:**
The frontend follows a component-based architecture with:
- Scene management using React Three Fiber's Canvas component
- Custom hooks for state management (Zustand stores)
- Separation of 3D components (Scene, DancingCharacter) from UI components
- CSS-in-JS approach using Tailwind's utility classes with custom HSL color variables

**3D Rendering Approach:**
- GLB/GLTF model loading for the dancing character
- Frame-based animation using `useFrame` hook
- Procedural animation (rotation, position, scaling) based on time
- Shadow casting and receiving for realistic lighting
- Orbit controls for camera interaction

**State Management:**
- Zustand for lightweight state management
- Separate stores for game state and audio state
- Subscription-based updates using `subscribeWithSelector` middleware

**Rationale:**
React Three Fiber was chosen over vanilla Three.js to leverage React's component model and hooks, making 3D scene management more declarative and easier to maintain. Zustand provides simpler state management compared to Redux while supporting advanced features like middleware.

### Backend Architecture

**Technology Stack:**
- **Express.js** for HTTP server
- **Node.js** with ESM modules
- **TypeScript** for type safety
- Separate development and production entry points

**Server Structure:**
- Dual-mode operation: development (with Vite HMR) and production (serving static files)
- Route registration system in `server/routes.ts`
- Logging middleware for request tracking
- Session-ready infrastructure (connect-pg-simple imported)

**Development vs Production:**
- **Development**: Vite middleware integration for HMR and on-the-fly transpilation
- **Production**: Pre-built static assets served from `dist/public`
- Index.html template transformation with cache-busting in development

**Storage Layer:**
- Interface-based design (`IStorage`) for data operations
- In-memory implementation (`MemStorage`) as default
- User CRUD operations defined (getUser, getUserByUsername, createUser)
- Prepared for database integration through interface swapping

**Rationale:**
The separation of dev and prod servers allows for optimal developer experience with HMR while maintaining production efficiency. The storage interface pattern enables easy migration from in-memory to database storage without changing business logic.

### Build System

**Vite Configuration:**
- Client-side build outputs to `dist/public`
- Path aliases (`@/` for client src, `@shared/` for shared code)
- GLSL shader support via vite-plugin-glsl
- Asset handling for 3D models and audio files (GLTF, GLB, MP3, OGG, WAV)
- Runtime error overlay for better debugging

**Build Process:**
1. Client build: Vite bundles React application
2. Server build: esbuild bundles Node.js server with external packages
3. TypeScript compilation check without emit

**Rationale:**
Vite provides significantly faster development builds than Webpack while esbuild handles server bundling efficiently. The dual-bundler approach optimizes each environment appropriately.

## External Dependencies

### Database

**Technology:** PostgreSQL (via Neon serverless)
- Connection through `@neondatabase/serverless` package
- Environment variable configuration (`DATABASE_URL`)
- Schema managed by Drizzle ORM

**Schema Definition:**
- Users table with id, username (unique), and password fields
- Zod validation schemas for type-safe inserts
- Drizzle configuration outputs migrations to `./migrations`

**Rationale:**
Neon provides serverless PostgreSQL with connection pooling suitable for Replit deployment. Drizzle ORM offers TypeScript-first schema definition with zero runtime overhead.

### UI Component Library

**Radix UI Primitives:**
Comprehensive collection of 30+ headless UI components including:
- Dialogs, Dropdowns, Popovers for overlays
- Form controls (Checkbox, Radio, Select, Slider, Switch)
- Navigation (Accordion, Tabs, Menubar)
- Feedback (Toast, Progress, Alert)

**Styling Approach:**
- Custom wrapper components in `client/src/components/ui/`
- TailwindCSS for styling with class-variance-authority for variants
- Shadcn-style component architecture

**Rationale:**
Radix provides accessible, unstyled primitives that work well with Tailwind, avoiding the constraints of opinionated component libraries while maintaining accessibility standards.

### Audio System

**Audio Management:**
- Native Web Audio API through HTML5 Audio elements
- Background music support (currently placeholder)
- Sound effects (hit, success sounds)
- Mute/unmute functionality

**Note:** Application currently uses placeholder audio path. To use specific music (e.g., "Latka" by Swarnalatha), audio files must be added to `client/public/sounds/`.

### 3D Assets

**Model Format:** GLB/GLTF
- Expected dancer model at `/geometries/dancer.glb`
- Shadow-enabled mesh processing
- Material support through Three.js standard materials

### Third-Party Services

**Development Tools:**
- `@replit/vite-plugin-runtime-error-modal` for error overlay
- TanStack Query for server state management (configured but not actively used)
- date-fns for date formatting utilities

**Font Loading:**
- Inter font via `@fontsource/inter` package
- Self-hosted font files to avoid external requests

### Session Management

**Infrastructure:**
- `connect-pg-simple` for PostgreSQL session storage
- Session configuration prepared but not implemented in routes

**Rationale:**
PostgreSQL-backed sessions provide persistence across server restarts and work well in serverless environments where in-memory sessions would be lost.