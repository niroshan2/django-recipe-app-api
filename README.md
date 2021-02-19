###### Commands

---

- To run migration scripts, note the 'core' at the end,
this is the app name

``docker-compose run app sh -c "python manage.py makemigrations core"
``

- To run tests
``docker-compose run --rm app sh -c "python manage.py test && flake8"``
  
---

- Terminologies
  
``is_superuser`` is a user that has full permissions to change anything.

``is_admin`` is to give the user access to the admin site.
  
---