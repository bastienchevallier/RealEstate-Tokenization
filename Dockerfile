# Use an official Node runtime as a parent image
FROM node:10.15.3-alpine

# Add git, which is not contain in alpine image
RUN apk update && apk upgrade &&\
    apk add --no-cache bash git openssh
RUN git config --global url."https://".insteadOf git://
# Add python and C compiler
RUN apk add --update g++ gcc libgcc libstdc++ make python krb5 krb5-libs krb5-dev &&\
    python --version

# Fine-tune the permission on our app code
RUN mkdir -p /home/node/app/node_modules

# Set the working directory to /app
WORKDIR /home/node/app

# Copy the current directory contents into the container
COPY package*.json ./

# Ensure that all of the application files are owned by the non-root node user
# USER node

# Install any needed packages specified in package.json
RUN npm cache clean -f &&\
    npm install

# Copy application code
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 8080

# Run start.js when the container launches
CMD ["node", "start.js"]
