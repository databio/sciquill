# How to write mail-merge letters with markmeld

## 1. Data

You need a `data.yaml` file like this. This is a list of people you want to send the letter to:

```yaml
people:
  - first_name: Bob
    last_name: Jones
    email: bob.jones@gmail.com
```

## 2. Letter

Write your letter in a jinja template like this `letter.jinja`:

```jinja
{% for person in people %}

<a href="mailto:{{ person.email }}?subject=SUBJECT&body=Hi {{person.first_name}},%0D%0A%0D%Letter contentt %0D%0A%0D%0AThanks, and we should catch up some time!%0D%0A%0D%0A-Nathan">{{ person.first_name }}</a>

{% endfor %}
```

## 3. Markmeld config in `_markmeld.yaml`:

Which is something like:

```yaml
imports:
  - $MMDIR/$HOSTNAME.yaml
targets:
  links:
    jinja_template: letter_template.jinja
    output_file: "{today}.html"
    data_yaml:
      - data.yaml
    command: |
      pandoc \
        -o {output_file}
```

Now just `mm links`, open the file, and you have personalized click links for all your letters. Easy peasy!
