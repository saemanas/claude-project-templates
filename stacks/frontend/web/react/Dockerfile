# React Frontend Dockerfile
# Multi-stage build for optimized production image

# ==============================================================================
# Stage 1: Builder
# ==============================================================================
FROM node:20-alpine as builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# ==============================================================================
# Stage 2: Production (Nginx)
# ==============================================================================
FROM nginx:alpine as production

# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost:3000 || exit 1

CMD ["nginx", "-g", "daemon off;"]
