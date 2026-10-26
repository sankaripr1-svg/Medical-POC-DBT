{% test lab_reference(model) %}
select * from {{ model }} where reference_low is not null and reference_high is not null and reference_low > reference_high
{% endtest %}
