# Use official Node.js LTS image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy app source code
COPY . .

# Build the app
RUN npm run build -- --webpack

# Expose port 3000
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
