
with Text_Io;
use Text_Io;


package body Sorting is

   package Int_Io is new Integer_Io(Integer);
   use Int_Io;

   pi : integer;

   pivot : integer;

   i : integer;
   j : integer := 0;
   temp : integer;
   
   function split(low: integer; high: integer) return Integer;

   procedure QSort(low: integer; high: integer) is
      procedure continue(x:integer) is
         task T1;
         task T2;
      
         task body T1 is 
         begin 
            QSort(low, x-1);
         end T1;

         task body T2 is 
         begin
            QSort(x+1, high); 
         end T2;

      begin
         null;
      end continue;
      

   begin
      if low >= high then
         return;
      else
         pi := split(low, high);
         continue(pi);
      end if;
   end QSort;

   function split(low: integer; high: integer) return Integer is
   begin 
      

      pivot := arr(high);

      i := low - 1;

      for j in low .. (high-1)
      loop
         if arr(j) < pivot then 
            i := i+1;
            temp := arr(i);
            arr(i) := arr(j);
            arr(j) := temp;
         end if;
      end loop;

      temp := arr(i+1);
      arr(i+1) := arr(high);
      arr(high) := temp;
      return (i + 1);
      
   end split;

end Sorting;

