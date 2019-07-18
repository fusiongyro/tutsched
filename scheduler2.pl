:- use_module(library(chr)).

:- chr_constraint open/2, open_slot/1, students/1, candidates/2, unavailable/2, scheduled/2.

%% generate open_slot(Hour) for each hour we're open
generate_open_slots @ open(Start, End) <=> Start < End | open_slot(Start), succ(Start, Next), open(Next, End).
generate_open_slots @ open(End, End) <=> true.

%% generate candidate(Student, Hour) for each student for each hour we're open
generate_candidates @ students(Students), open_slot(Hour) ==> candidates(Hour, Students).

%% remove candidates when students are unavailable
remove_unavailable @
unavailable(Student, Hour),
candidates(Hour, Students)
<=> once(select(Student, Students, Remaining)), candidates(Hour, Remaining).

%% if only one candidate is available at an hour, schedule them there
only_one_candidate @ candidates(Hour, [Name]), open_slot(Hour) <=> scheduled(Name, Hour).

