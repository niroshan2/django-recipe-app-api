FROM python:3.7-alpine
MAINTAINER niro-test

# What this does is it tells Python to run in unbuffered mode which is recommended when running Python within docker containers.
# The reason for this is that it doesn't allow Python to buffer the outputs.
# It just prints them directly.And this avoids some complications and things like that with the Docker image when you're running your python application.
ENV PYTHONUNBUFFERED 1

# What this does is it says copy from the directory adjacent to the Docker file, copy the requirements
# file that we're going to create here and copy it on the Docker image to /requirements.txt
COPY ./requirements.txt /requirements.txt

# So what this does is it takes the requirements file that we've just copied and it installs it using pip into
# the Docker image.
RUN pip install -r /requirements.txt

# What this does is it creates a empty folder on our docker container at this location '/app'
# and then it switches to that as the default directory.
# So any application we run using our docker container will run straight from this location unless we specify otherwise.
RUN mkdir /app
WORKDIR /app

# Next what it does is it copies from our local machine app folder to the app folder that we've created on an image.
# This allows us to take the code that we created in our products here and copy it into our Docker image.
COPY ./app /app

# Next we're going to create a user that is going to run our application using docker.
# We have time run and user with the -D user and finally we're going to switch to that user by typing user user.

# Now it might be a bit confusing here because I've used the user name user for our user.
# But what this means command says is basically says add user which creates a user
# that is going to be used for running applications only. So, not for basically having a home directory and that someone will log in to it's going to be used simply
# to run our processes from our project.
# And finally this user user switches docker to the user that we've just created.
# The reason why we do this is for security purposes.
# If you don't do this then the image will run our application using the root account which is not recommended
# because that means if somebody compromises our application they then have access to the whole image
# and they can go do other than vicious things.
# Whereas if you create a separate user just for our application then this kind of limits the scope that an attacker would have in our documentation.
RUN adduser -D user
USER user