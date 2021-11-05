
package Sorting is

   procedure QSort(low: integer; high: integer);

   SIZE : integer:= 40;
   subtype limit is Integer range 0 .. 500;
   type table is array(1 .. SIZE) of limit;
   arr : table;

end Sorting;
