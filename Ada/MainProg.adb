
with Ada.Text_IO;   
use Ada.Text_IO;    
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with Sorting;
use Sorting;

procedure MainProg is

    
    global_sum : integer := 0;

    task printingTask is
        entry firstPrintingStart;
        entry secondPrintingStart;
        entry printSum;
    end printingTask;

    task sortingTask is 
        entry sortingStart;
    end sortingTask;

    task addingTask is 
        entry startAdding;
    end addingTask;

    task body printingTask is 
    begin
        accept firstPrintingStart do
            new_line;
            new_line;
            put("Printing elements for the first time");
            new_line;
            for i in 1 .. SIZE
            loop
                put(arr(i));
            end loop;
            New_Line;
        end firstPrintingStart;

        sortingTask.sortingStart;

        accept secondPrintingStart do
            new_line;
            new_line;
            put("Printing elements after they are sorted");
            new_line;
            for i in 1 .. SIZE
            loop
                put(arr(i));
            end loop;
            New_Line;
        end secondPrintingStart;

        accept printSum do
            new_line;
            new_line;
            put("Sum of array received from adding task ");
            new_line;
            put(global_sum);
            new_line;
        end printSum;

    end printingTask;

    task body sortingTask is
    begin
        accept sortingStart do
            Sorting.QSort(1,SIZE);
        end sortingStart;

        printingTask.secondPrintingStart;
        addingTask.startAdding;

    end sortingTask;

    task body addingTask is 
    begin
        accept startAdding do 
            for i in 1 .. SIZE
            loop
                global_sum:= global_sum + arr(i);
            end loop;
        end startAdding;

        printingTask.printSum;

    end addingTask;

    
begin
    for i in 1 .. SIZE
    loop 
        get(arr(i));
        
    end loop;
    printingTask.firstPrintingStart;

end MainProg;