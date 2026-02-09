-- normalize_product.sql
-- maps legacy CFPB product names to their current equivalents
-- the CFPB consolidated several product categories over the years
-- without this, trend analysis shows fake drops when products get renamed

{% macro normalize_product(column_name) %}
    case
        when {{ column_name }} = 'Credit card'
            then 'Credit card or prepaid card'
        when {{ column_name }} = 'Prepaid card'
            then 'Credit card or prepaid card'
        when {{ column_name }} = 'Payday loan'
            then 'Payday loan, title loan, or personal loan'
        when {{ column_name }} = 'Virtual currency'
            then 'Money transfer, virtual currency, or money service'
        when {{ column_name }} = 'Money transfers'
            then 'Money transfer, virtual currency, or money service'
        when {{ column_name }} = 'Consumer Loan'
            then 'Payday loan, title loan, or personal loan'
        when {{ column_name }} = 'Bank account or service'
            then 'Checking or savings account'
        else {{ column_name }}
    end
{% endmacro %}
