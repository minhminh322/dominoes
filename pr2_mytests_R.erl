% Minh Phan
% Project 2 - TCSS 380 Spring 2019
% 6/7/2019

-module('pr2_mytests_R').
-include_lib("eunit/include/eunit.hrl").


%these dominoes test just test if the full list is created
dominoes_1_test()->
    ?assertEqual([{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}], pr2_R:dominoes(2)).

dominoes_2_test()->
    ?assertEqual([{0,0}], pr2_R:dominoes(0)).

flip_Case_1_test() ->
        %using true matching pattern
        MyList = [{2,1},{1,1},{1,0},{0,0},{2,0},{2,2}],
        true = [{2,1},{1,1},{1,0},{0,0},{0,2},{2,2}] == pr2_R:flip(MyList).
    
flip_Case_2_test() ->
        %using true matching pattern
        MyList = [{4,1},{1,1},{1,0},{0,0},{2,0},{2,1},{1,3},{3,3},{0,3},{0,4},{4,4},{2,4},{2,2},{3,2},{3,4}],
        true = [{4,1},{1,1},{1,0},{0,0},{0,2},{2,1},{1,3},{3,3},{3,0},{0,4},{4,4},{4,2},{2,2},{2,3},{3,4}] == pr2_R:flip(MyList).
    
%solution test loops itself to see if it ever gets the result it is supposed to, true in this case
solution_1_test()->
    Temp = pr2_R:solution(2),
    case pr2_R:isRing(Temp) of 
        true-> true;
        false-> solution_1_test(10)
    end.
solution_1_test(0)->false;
solution_1_test(N)->
    Temp = pr2_R:solution(2),
    case pr2_R:isRing(Temp) of 
        true-> true;
        false-> solution_1_test(N-1)
    end.

%this one is false since isring shoulf be passed an empty list
solution_2_test()->
    ?assertEqual(false, pr2_R:isRing(pr2_R:solution(3))).
solution_3_test()->
    ?assertEqual([], pr2_R:solution(3)).
solution_4_test()->
    ?assertEqual(true, pr2_R:isRing(pr2_R:solution(6))).

%this one simply checks what listAsString generates versus what is should be generating
listAsString_1_test()->
        ?assertEqual("[ {1, 1}, {1, 0}, {0, 2} ]",pr2_R:listAsString([{1,1},{1,0},{0,2}])).
       

%this one combines listAsSting test with solution test to see if driver ever gives the correct string
driver_test()->
    case "[ {1, 1}, {1, 0}, {0, 0}, {0, 2}, {2, 2}, {2, 1} ]"== pr2_R:driver(fun pr2_R:listAsString/1,fun pr2_R:solution/1, 2) of
        true-> true;
        false-> driver_test(50)
    end.

driver_test(0)->false;
driver_test(N)->
    case "[ {1, 1}, {1, 0}, {0, 0}, {0, 2}, {2, 2}, {2, 1} ]"== pr2_R:driver(fun pr2_R:listAsString/1,fun pr2_R:solution/1, 2) of
        true-> true;
        false-> driver_test(N-1)
    end.

%similar to solution this one loops intslef untill it randomly generates the correct list, although it can fail if not gerneating fast enough
giveRandom_1_test()->
    case compare([{1,1},{1,0},{0,0},{0,2},{2,2},{2,1}],pr2_R:flip(pr2_R:giveRandom(pr2_R:dominoes(2)))) of
        true-> true;
        false-> giveRandom_1_test(50)
    end.
%this does lead to some false positives, but that just proves that isRandom is creating randomly
giveRandom_1_test(0)->false;
giveRandom_1_test(N)->
    case compare([{1,1},{1,0},{0,0},{0,2},{2,2},{2,1}], pr2_R:flip(pr2_R:giveRandom(pr2_R:dominoes(2)))) of
        true-> true;
        false-> giveRandom_1_test(N-1)
    end.

%this one checks if israndom can generate loops not using all of the domineos in the same awy as the above test
giveRandom_2_test()->
    case compare([{1,0},{0,2},{2,2},{2,1},{1,1}],pr2_R:flip(pr2_R:giveRandom(pr2_R:dominoes(2)))) of
        true-> true;
        false-> giveRandom_2_test(50)
    end.
giveRandom_2_test(0)->false;
giveRandom_2_test(N)->
    case compare([{1,0},{0,2},{2,2},{2,1},{1,1}], pr2_R:flip(pr2_R:giveRandom(pr2_R:dominoes(2)))) of
        true-> true;
        false-> giveRandom_2_test(N-1)
    end.

%this ones tests if give random gives lists that it shouldnt bu checking 10000 times if isRandom generates an impossible list
giveRandom_3_test()->
    case compare([{1,0},{0,2},{2,2},{2,1},{1,3}],pr2_R:flip(pr2_R:giveRandom(pr2_R:dominoes(2)))) of
        true-> false;
        false-> giveRandom_3_test(10000)
    end.
giveRandom_3_test(0)->true;
giveRandom_3_test(N)->
    case compare([{1,0},{0,2},{2,2},{2,1},{1,3}], pr2_R:flip(pr2_R:giveRandom(pr2_R:dominoes(2)))) of
        true-> false;
        false-> giveRandom_3_test(N-1)
    end.


%another set of simple tests setup to eather give true or false dependingg on the lsits I wrote in by hand
isRing_1_test()->
    ?assertEqual(true, pr2_R:isRing([{0,0},{0,1},{1,1},{1,2},{2,2},{2,0}])).
isRing_2_test()->
    ?assertEqual(false, pr2_R:isRing([{0,0},{1,1},{1,0},{1,2},{2,2},{2,0}])). %this one gives false cause it is not a valid loop
isRing_3_test()->
    ?assertEqual(false, pr2_R:isRing([{2,1},{1,0},{0,0},{2,0}])). %this one gives false cause ti is too short


%intertnal method I use to compare lists of dominoes
compare([],[])->true;
compare([H1|T1],[H2|T2])->
    case H1 == H2 of
        true -> compare(T1,T2);
        false -> false
    end.

