%% Tiny scheduler for students.
%%
%% Round 1, let's allocate students to hours.

:- use_module(library(chr)).
:- chr_constraint open/2, open_slot/2, schedule_candidate/3, schedule/3, student/2, student_hours/2.

:- op(400, xfy, on).

%% ---------------------------------------------------------------------------
%%
%%    S C H E D U L I N G   I N P U T S
%%
%% ---------------------------------------------------------------------------

%% This section contains the facts about the schedule that must be
%% generated. It is a good idea to edit this section to make a new
%% schedule.

/*
%% student(Name, HoursPerWeek)
student(harvey, 10).
student(melissa, 10).
student(todd, 10).
student(grace, 10).

%% let's talk about when they are unavailable:
unavailable(harvey, 10 on tr).
unavailable(harvey, 2-4 on tr).
unavailable(melissa, mfs).
unavailable(grace, 9-11 on mwf).
unavailable(grace, 2-4 on tr).

%% we're open... 
open(mtwrf, 10-20).  % M-F 10 AM to 8 PM
open(s, 12-17).      % and Saturday 12 to 5 PM
*/
  
%% ---------------------------------------------------------------------------
%%
%%    S C H E D U L I N G   F U N C T I O N A L I T Y
%%
%% ---------------------------------------------------------------------------

%% This section contains the code to generate the schedule and should
%% probably not be edited.

%% First, some utility rules for handling our times
day_of_days(Day, Days) :-
    sub_atom(Days, _, 1, _, Day).

in_range(Day, Hour, Hour on Days) :-
    number(Hour),
    day_of_days(Day, Days).
in_range(Day, Hour, Start-End on Days) :-
    day_of_days(Day, Days),
    succ(End0, End),
    between(Start, End0, Hour).
in_range(Day, Hour, Days) :-
    atomic(Days),
    day_of_days(Day, Days),
    between(0, 23, Hour).

%% the first step here is to project our open hours to slots
generate_open_slots @ open(Days, Open-Close) <=> Open < Close | open_slot(Days, Open), succ(Open, Next), open(Days, Next-Close).
generate_open_slots @ open(_, Close-Close) <=> true.

generate_open_slot_days @ open_slot(Days, Hour) <=> atom_length(Days, X), X > 1 | day_of_days(Day, Days), open_slot(Day, Hour), open_slot

/*
%% second step, for every hour that a student is available and the
%% center is open, this day-hour-student set is a candidate slot
generate_candidate_assignments @
student(Student, _),
open(Day, Hour)
==>
schedule_candidate(Day, Hour, Student).

%% third step, for every hour that a student is unavailable, remove
%% the candidate slot
remove_unavailable_time @
unavailable(Student, TimeRange) \
schedule_candidate(Day, Hour, Student)
| in_range(Day, Hour, TimeRange)
<=>
true.

%% fourth step, if there is exactly one schedule candidate at a given
%% hour, that student is scheduled at that time:
one_candidate @
schedule_candidate(Day, Hour, Student),
student_hours(Student, RemainingHours)
| \+ schedule_candidate(Day, Hour, OtherStudent), dif(Student, OtherStudent)
==>
succ(RemainingHours0, RemainingHours),
student_hours(Student, RemainingHours0),
schedule(Student, Day, Hour).

%% fifth step, if a student runs out of hours, they are no longer a
%% candidate for anything:
out_of_hours @
student_hours(Student, 0)
\
schedule_candidate(_, _, Student).

%% at this point, we have only figured out which students _must_ work
%% certain times, we have not started assigning students to various
%% times.
*/