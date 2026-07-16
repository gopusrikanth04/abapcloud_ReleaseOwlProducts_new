projection;
strict ( 2 );

define behavior for ZRO_C_PRODUCTS //alias <alias_name>
{
  use create;
  use update;
  use delete;

  use association _prod_sepcs { create; }
}

define behavior for ZRO_C_PROD_SPECS //alias <alias_name>
{
  use update;
  use delete;

  use association _products;
}