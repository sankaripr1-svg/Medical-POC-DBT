{% test accepted_gender(model, column_name) %}
select * from {{ model }} where {{ column_name }} is not null and {{ column_name }} not in ('MALE', 'FEMALE', 'OTHER', 'UNKNOWN')
{% endtest %}
