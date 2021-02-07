###### Commands

---

- To run migration scripts, note the 'core' at the end,
this is the app name

``docker-compose run app sh -c "python manage.py makemigrations core"
``

- To run tests
``docker-compose run --rm app sh -c "python manage.py test"``