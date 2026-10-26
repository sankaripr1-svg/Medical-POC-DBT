{% test claim_amounts(model) %}
select * from {{ model }} where claim_amount < 0 or approved_amount < 0 or approved_amount > claim_amount
{% endtest %}
