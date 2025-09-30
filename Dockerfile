# Stage 1: Build React app using Node.js 18 from AWS ECR Public
FROM public.ecr.aws/docker/library/node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy app source code
COPY . .

# Build the React app (outputs to /app/build by default for CRA)
RUN npm run build


# Stage 2: Use NGINX from AWS ECR Public
FROM public.ecr.aws/docker/library/nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy React build output from builder stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
