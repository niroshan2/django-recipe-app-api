from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

# This is the recommended convention for converting strings in our
# Python to human readable text and the reason we do this is just so it gets
# passed through the translation engine so we're not going to be doing anything
# with translation in this course but if you did want to extend the code to
# support multiple languages then this would make it a lot easier for you to do
# that because you basically just set up the translation files and then it will
# convert the text appropriately.
from django.utils.translation import gettext as _


from core import models


# 1. Why we are importing 'UserAdmin' with alias 'BaseUserAdmin'
# (from django.contrib.auth.admin import UserAdmin as BaseUserAdmin)
#   Ans: We are importing UserAdmin with an alias BaseUserAdmin
#   because otherwise it will conflict with our UserAdmin class.

# 2. Why are we extending UserAdmin with BaseUserAdmin.
# Ans: We are extending UserAdmin with BaseUserAdmin because we want to
# include the base functionality that comes with Django so we get
# the features to manage our users within the Django admin
# (eg: change password...)
class UserAdmin(BaseUserAdmin):
    ordering = ['id']
    list_display = ['email', 'name']
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (_('Personal Info'), {'fields': ('name',)}),
        (
            _('Permissions'),
            {'fields': ('is_active', 'is_staff', 'is_superuser')}
        ),
        (_('Important dates'), {'fields': ('last_login',)})
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2')
        }),
    )


admin.site.register(models.User, UserAdmin)
