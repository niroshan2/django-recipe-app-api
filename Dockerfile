FROM python:3.7-alpine
MAINTAINER niro-test

# What this does is it tells Python to run in unbuffered mode which is recommended when running Python within docker containers.
# The reason for this is that it doesn't allow Python to buffer the outputs.
# It just prints them directly.And this avoids some complications and things like that with the Docker image when you're running your python application.
ENV PYTHONUNBUFFERED 1

# What this does is it says copy from the directory adjacent to the Docker file, copy the requirements
# file that we're going to create here and copy it on the Docker image to /requirements.txt
COPY ./requirements.txt /requirements.txt

# What this does is it uses the package manager that comes with Alpine
# and it says this is the name of the package manager apk and we're going add a package
# and this update means update the registry before we add it but this no cache means don't store the registry
# index on our docker file. The reason we do this is because we really
# want to minimize the number of extra files and packages that are included in
# our docker container. This is best practice because it means that your
# docker container for your application has the smallest footprint possible and
# it also means that you don't include any extra dependencies or anything on your
# system which may cause unexpected side effects or it may even create security
# vulnerabilities in your system.
RUN apk add --update --no-cache postgresql-client

# RUN - This is the Dockerfile command for running a command during the build phase

# apk - This is the Alpine package manager command

# add - This is the Alpine package manager command for adding packages

# --update - This tells the package manager to update the package index before installing packages
#(similar to running apt-get update on a Ubuntu based OS)

# --no-cache - This tells the package manager to not cache the index,
#this is because we don't want the index cached on our Docker image, as the goal is to keep the image as small as possible

# --virtual .tmp-build-deps - This tells the package manager to store any dependencies under the virtual name ".tmp-build-deps",
#which allows us to remove installed packages in one go (we do this below in line 'RUN apk del .tmp-build-deps')

# The rest (gcc libc-dev linux-headers postgresql-dev) are names of packages to install.

# So, why do we install these packages under the virtual name .tmp-build-deps only to remove them a few lines later?
# We do this because these packages are only required for installing the Python requirements in this line 'RUN pip install -r /requirements.txt'.
#Once we've installed them, we can remove the temporary packages (again, to keep the image as lightweight as possible)
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev

# So what this does is it takes the requirements file that we've just copied and it installs it using pip into
# the Docker image.
RUN pip install -r /requirements.txt

# Okay now that the temporary requirements are
# installed we can then leave this run line here which will
# run our install for our requirements.
# And below that we can add a line that
# deletes the temporary requirements which we do by typing
# RUN apk del and then the name the alias that we set up here so it's tmp-build-deps
RUN apk del .tmp-build-deps

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