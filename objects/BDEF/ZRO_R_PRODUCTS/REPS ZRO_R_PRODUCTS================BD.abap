managed implementation in class zbp_ro_r_products unique;
strict ( 2 );

define behavior for ZRO_R_PRODUCTS //alias <alias_name>
persistent table zro_products
lock master
authorization master ( instance )
//etag master <field_name>
{
  create ( authorization : global );
  update;
  delete;
  field ( numbering : managed ) Guid;
  field ( readonly ) Guid;
validation validateProduct on save { create; update; }
  association _prod_sepcs { create; }

  mapping for zro_products
    {
      Guid        = guid;
      Name        = name;
      Description = description;
      Rating      = rating;
      Price       = price;
      Createdby   = createdby;
      Createdon   = createdon;
      Changedby   = changedby;
      Changedon   = changedon;
    }
}

define behavior for ZRO_R_PROD_SPECS //alias <alias_name>
persistent table zro_product_spec
lock dependent by _products
authorization dependent by _products
//etag master <field_name>
{
  update;
  delete;
  field ( readonly ) Guid, Refguid;
  field ( numbering : managed ) Guid;
  association _products;
  mapping for zro_product_spec
    {
      Guid        = guid;
      Refguid     = refguid;
      Productname = productname;
      SpecGroup   = spec_group;
      SpecName    = spec_name;
      SpecValue   = spec_value;
      Createdby   = createdby;
      Createdon   = createdon;
      Changedby   = changedby;
      Changedon   = changedon;
    }
}