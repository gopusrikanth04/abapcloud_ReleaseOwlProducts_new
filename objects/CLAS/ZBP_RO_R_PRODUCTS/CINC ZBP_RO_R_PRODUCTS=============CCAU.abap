*"* use this source file for your ABAP unit test classes
CLASS ltcl_products DEFINITION FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_create_product  FOR TESTING,
      test_update_product  FOR TESTING,
      test_delete_product  FOR TESTING,
      test_create_product1 FOR TESTING.
*      test_failed_product  FOR TESTING.
ENDCLASS.

CLASS ltcl_products IMPLEMENTATION.

  METHOD test_create_product.

    DATA:
      lt_mapped   TYPE RESPONSE FOR MAPPED zro_r_products,
      lt_failed   TYPE RESPONSE FOR FAILED zro_r_products,
      lt_reported TYPE RESPONSE FOR REPORTED zro_r_products.

    MODIFY ENTITIES OF zro_r_products
      ENTITY zro_r_products
      CREATE
      SET FIELDS WITH VALUE #(
        (
         %cid = 'C1'
          Name        = 'Laptop'
          Description = 'Unit Test Product'
          Rating      = 5
          Price       = '1000.00'
        )
      )
      MAPPED   lt_mapped
      FAILED   lt_failed
      REPORTED lt_reported.

    cl_abap_unit_assert=>assert_initial( lt_failed ).
    cl_abap_unit_assert=>assert_not_initial( lt_mapped ).

  ENDMETHOD.

  METHOD test_delete_product.

    DATA:
      lt_mapped TYPE RESPONSE FOR MAPPED zro_r_products,
      lt_failed TYPE RESPONSE FOR FAILED zro_r_products.

    "--------------------------------------------------
    " Step 1 – Create product (required for delete test)
    "--------------------------------------------------
    MODIFY ENTITIES OF zro_r_products
      ENTITY zro_r_products
      CREATE
      SET FIELDS WITH VALUE #(
        (
          %cid  = 'C1'        " Mandatory for CREATE
          Name  = 'Tablet'
          Price = '300.00'
        )
      )
      MAPPED lt_mapped
      FAILED lt_failed.

    cl_abap_unit_assert=>assert_initial( lt_failed ).

    READ TABLE lt_mapped-zro_r_products INDEX 1 INTO DATA(ls_mapped).

    cl_abap_unit_assert=>assert_not_initial( ls_mapped ).

    "--------------------------------------------------
    " Step 2 – Delete created product
    "--------------------------------------------------
    MODIFY ENTITIES OF zro_r_products
      ENTITY zro_r_products
      DELETE
      FROM VALUE #(
        ( %tky = ls_mapped-%tky )
      )
      FAILED lt_failed.

    cl_abap_unit_assert=>assert_initial( lt_failed ).

    "--------------------------------------------------
    " Step 3 – Verify product is deleted
    "--------------------------------------------------
    READ ENTITIES OF zro_r_products
      ENTITY zro_r_products
      ALL FIELDS
      WITH VALUE #(
        ( %tky = ls_mapped-%tky )
      )
      RESULT DATA(lt_result).

    cl_abap_unit_assert=>assert_initial( lt_result ).



  ENDMETHOD.

  METHOD test_update_product.

    DATA:
      lt_mapped TYPE RESPONSE FOR MAPPED zro_r_products,
      lt_failed TYPE RESPONSE FOR FAILED zro_r_products,
      lt_result TYPE TABLE FOR READ RESULT zro_r_products.

    " Step 1 – Create
    MODIFY ENTITIES OF zro_r_products
      ENTITY zro_r_products
      CREATE
      SET FIELDS WITH VALUE #(
        (
          %cid  = 'C1'
          Name  = 'Phone'
          Price = '500.00'
        )
      )
      MAPPED lt_mapped
      FAILED lt_failed.

    cl_abap_unit_assert=>assert_initial( lt_failed ).

    READ TABLE lt_mapped-zro_r_products INDEX 1 INTO DATA(ls_mapped).

    " Step 2 – Update
    MODIFY ENTITIES OF zro_r_products
      ENTITY zro_r_products
      UPDATE
      SET FIELDS WITH VALUE #(
        (
          %tky   = ls_mapped-%tky
          Price  = '800.00'
        )
      )
      FAILED lt_failed.

    cl_abap_unit_assert=>assert_initial( lt_failed ).

    " Step 3 – Read & Validate
    READ ENTITIES OF zro_r_products
      ENTITY zro_r_products
      ALL FIELDS
      WITH VALUE #(
        ( %tky = ls_mapped-%tky )
      )
      RESULT lt_result.

    READ TABLE lt_result INDEX 1 INTO DATA(ls_result).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-Price
      exp = '800.00'
    ).
  ENDMETHOD.

  METHOD test_create_product1.

    DATA:
      lt_failed TYPE RESPONSE FOR FAILED zro_r_products.

    " Try to update with invalid technical key
    MODIFY ENTITIES OF zro_r_products
      ENTITY zro_r_products
      UPDATE
      SET FIELDS WITH VALUE #(
        (
          %tky  = VALUE #( )   " Invalid empty key
          Price = '99999999.00'
        )
      )
      FAILED lt_failed.

    " Expect failure
    cl_abap_unit_assert=>assert_not_initial( lt_failed ).

  ENDMETHOD.

*  METHOD test_failed_product.
*
*
*    DATA:
*      lt_mapped   TYPE RESPONSE FOR MAPPED zro_r_products,
*      lt_failed   TYPE RESPONSE FOR FAILED zro_r_products,
*      lt_reported TYPE RESPONSE FOR REPORTED zro_r_products.
*
*    MODIFY ENTITIES OF zro_r_products
*      ENTITY zro_r_products
*      CREATE
*      SET FIELDS WITH VALUE #(
*        (
*          %cid  = 'C1'
*          Name  = ''          " Invalid
*          Price = '-100.00'   " Invalid
*          Rating = 10         " Invalid
*        )
*      )
*      MAPPED   lt_mapped
*      FAILED   lt_failed
*      REPORTED lt_reported.
*
*    cl_abap_unit_assert=>assert_not_initial( lt_failed ).
*    cl_abap_unit_assert=>assert_initial( lt_mapped ).
*

*  ENDMETHOD.

ENDCLASS.