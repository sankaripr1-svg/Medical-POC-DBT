{% test encounter_dates(model) %}
select * from {{ model }} where discharge_time is not null and discharge_time < admission_time
{% endtest %}
