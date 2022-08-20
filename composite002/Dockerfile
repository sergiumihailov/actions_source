# Pull the minimal Ubuntu image
FROM ubuntu:latest
# Update repo and Install Nginx
RUN apt-get -y update && apt-get -y install \
    nginx
# Copy the Nginx config
COPY default.conf /etc/nginx/sites-available/default
COPY index.html /usr/share/nginx/html
# Expose the port for access
EXPOSE 80
# Run the Nginx server
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
