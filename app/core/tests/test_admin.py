from django.test import TestCase, Client
from django.contrib.auth import get_user_model
from django.urls import reverse


class AdminSiteTests(TestCase):

    def setUp(self):
        self.client = Client()  # TODO: Find purpose of client()
        self.admin_user = get_user_model().objects.create_superuser(
            email='admin@londonappdev.com',
            password='password123'
        )
        self.client.force_login(self.admin_user)
        self.user = get_user_model().objects.create_user(
            email='test@londonappdev.com',
            password='password123',
            name='Test user full name'
        )

    def test_users_listed(self):
        """Test that users are listed on user page"""
        # create the URL first
        # using the reverse helper function
        # and reverse the way you use it is you simply
        # type the app that you're going for : and then the URL that
        # you want so we want
        # core_user_changelist
        # These URLs are actually defined in the Django admin
        # And basically what this
        # will do is it will generate the URL for our list user page.
        # and the reason we
        # use this reverse function instead of just typing the
        # URL manually is because if we ever want to change the
        # URL in a future it means we don't have to go
        # through and change it everywhere in our test
        # because it should update automatically based on reverse.
        # see this page
        # https://docs.djangoproject.com/en/2.2/ref/contrib/admin/#reversing-admin-urls
        url = reverse('admin:core_user_changelist')
        print(f">>> urls is {url}")

        res = self.client.get(url)
        print(f">>> type of res is {type}{res}")
        print(f">>> res is {res}")

        self.assertContains(res, self.user.name)
        self.assertContains(res, self.user.email)

    def test_user_change_page(self):
        """Test that the user edit page works"""
        url = reverse('admin:core_user_change', args=[self.user.id])
        # above line generates a url like this - /admin/core/user/1
        res = self.client.get(url)

        # 3.1 Test passing because setUp creates a user with email field,
        # self.assertContains(res, self.user.email)

        # 3.2 Test failing because setUp user doesn't have last_name field
        # self.assertContains(res, self.user.last_name)
        self.assertEqual(res.status_code, 200)

    def test_create_user_page(self):
        """Test that the create user page works"""
        url = reverse('admin:core_user_add')
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)
