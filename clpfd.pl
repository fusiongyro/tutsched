:- use_module(library(clpfd)).

main :-
    %% let's say we have four people,
    %%
    %% alice
    %% bob
    %% chandra
    %% dave
    %%
    %% we're open eight hours
    %% each person should work at most

    %% who's scheduled per hour (A8 = Alice at 8)
    [A08, A09, A10, A11, A12, A01, A02, A03] ins 0..1,
    [B08, B09, B10, B11, B12, B01, B02, B03] ins 0..1,
    [C08, C09, C10, C11, C12, C01, C02, C03] ins 0..1,
    [D08, D09, D10, D11, D12, D01, D02, D03] ins 0..1,

    %% we need two people on each hour
    A08 + B08 + C08 + D08 #= 2,
    A09 + B09 + C09 + D09 #= 2,
    A10 + B10 + C10 + D10 #= 2,
    A11 + B11 + C11 + D11 #= 2,
    A12 + B12 + C12 + D12 #= 2,
    A01 + B01 + C01 + D01 #= 2,
    A02 + B02 + C02 + D02 #= 2,
    A03 + B03 + C03 + D03 #= 2,
    
    %% nobody can work more than four hours in a day
    A08 + A09 + A10 + A11 + A12 + A01 + A02 + A03 #< 5,
    B08 + B09 + B10 + B11 + B12 + B01 + B02 + B03 #< 5,
    C08 + C09 + C10 + C11 + C12 + C01 + C02 + C03 #< 5,
    D08 + D09 + D10 + D11 + D12 + D01 + D02 + D03 #< 5,

    %% nobody can work more than three hours in a row
    A08 + A09 + A10 + A11 #< 4, A09 + A10 + A11 + A12 #< 4,
    A10 + A11 + A12 + A01 #< 4, A11 + A12 + A01 + A02 #< 4,
    A12 + A01 + A02 + A03 #< 4,
    
    B08 + B09 + B10 + B11 #< 4, B09 + B10 + B11 + B12 #< 4,
    B10 + B11 + B12 + B01 #< 4, B11 + B12 + B01 + B02 #< 4,
    B12 + B01 + B02 + B03 #< 4,
    
    C08 + C09 + C10 + C11 #< 4, C09 + C10 + C11 + C12 #< 4,
    C10 + C11 + C12 + C01 #< 4, C11 + C12 + C01 + C02 #< 4,
    C12 + C01 + C02 + C03 #< 4,

    D08 + D09 + D10 + D11 #< 4, D09 + D10 + D11 + D12 #< 4,
    D10 + D11 + D12 + D01 #< 4, D11 + D12 + D01 + D02 #< 4,
    D12 + D01 + D02 + D03 #< 4,

    label([A08, A09, A10, A11, A12, A01, A02, A03,
           B08, B09, B10, B11, B12, B01, B02, B03,
           C08, C09, C10, C11, C12, C01, C02, C03,
           D08, D09, D10, D11, D12, D01, D02, D03]),
    display([['Alice   ', A08, A09, A10, A11, A12, A01, A02, A03],
             ['Bob     ', B08, B09, B10, B11, B12, B01, B02, B03],
             ['Chandra ', C08, C09, C10, C11, C12, C01, C02, C03],
             ['Duane   ', D08, D09, D10, D11, D12, D01, D02, D03]]).

display(Students) :-
    write('        | 08 09 10 11 12 01 02 03'),  nl,
    write('--------+-------------------------'), nl,
    display_loop(Students).

display_loop([[Name, A08, A09, A10, A11, A12, A01, A02, A03]|Rest]) :-
    write(Name), write('|'),
    display_xs([A08, A09, A10, A11, A12, A01, A02, A03]),
    nl,
    display_loop(Rest).
display_loop([]).

display_xs([1|Xs]) :-
    write(' X '), display_xs(Xs).
display_xs([0|Xs]) :-
    write('   '), display_xs(Xs).
display_xs([]).

/*
        | 08 09 10 11 12 01 02 03
--------+------------------------- 
Alice:  |  X  X  X     X
Bob:    |     X  X  X  X
*/