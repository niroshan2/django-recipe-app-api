from django.test import TestCase
from django.contrib.auth import get_user_model


# 'from django.contrib.auth import get_user_model' helper
# function that comes with Django.
# You can import the user model directly from the models but this is
# not recommended with django because at some
# point in the project you may want to change what your user
# model is and if everything is using the get user
# model function then that's really easy to do
# because you just change it in the settings instead of
# having to change all the references to the user model.
class ModelTests(TestCase):

    def test_create_user_with_email_successful(self):
        """Test creating a new user with an email is successful"""
        email = 'test@londonappdev.com'
        password = 'Testpass123'
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        """Test the email for a new user is normalised"""
        email = 'test@LONDONAPPDEV.COM'
        user = get_user_model().objects.create_user(email, 'test123')

        self.assertEqual(user.email, email.lower())

    def test_new_user_invalid_email(self):
        """Test creating user with no email raises error"""
        with self.assertRaises(ValueError):
            get_user_model().objects.create_user(None, 'test123')

    def test_create_new_superuser(self):
        """Test creating a new superuser"""
        user = get_user_model().objects.create_superuser(
            'test@londonappdev.com',
            'test123'
        )

        # You may be
        # wondering where the is_superuser field is on
        # our user model because we didn't add it in 'User' but it is
        # included as part of the PermissionsMixin.
        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)
