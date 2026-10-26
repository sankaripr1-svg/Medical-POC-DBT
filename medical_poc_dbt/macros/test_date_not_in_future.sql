{% test date_not_in_future(model, column_name) %}
select * from {{ model }} where {{ column_name }} is null or {{ column_name }} > current_date()
{% endtest %}
