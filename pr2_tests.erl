% Minh Phan
% Project 2 - TCSS 380 Spring 2019
% 6/7/2019

-module('pr2_tests').
-include_lib("eunit/include/eunit.hrl").

dominoes_Even_test() ->
    %using true matching pattern
    true = [{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}] == pr2_R:dominoes(2).

dominoes_Odd_test() ->
    %using true matching pattern
    true = [{3,3},{3,2},{3,1},{3,0},{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}] == pr2_R:dominoes(3).

isRing_True_Case_1_test() ->
    %using true matching pattern
    MyList = [{2,1},{1,1},{1,0},{0,0},{2,0},{2,2}],
    true = true == pr2_R:isRing(MyList).

isRing_True_Case_2_test() ->
    %using true matching pattern
    MyList = [{3,2},{2,2},{2,0},{0,4},{4,3},{3,0},{0,0},{0,1},{1,1},{1,4},{4,4},{4,2},{2,1},{1,3},{3,3}],
    true = true == pr2_R:isRing(MyList).

isRing_False_Case_1_test() ->
    %using true matching pattern
    MyList = [{2,1},{1,0},{0,0},{2,0}],
    true = false == pr2_R:isRing(MyList).

isRing_False_Case_2_test() ->
    %using true matching pattern
    MyList = [{3,3},{3,2},{3,1},{3,0},{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}],
    true = false == pr2_R:isRing(MyList).

isRing_False_Case_3_test() ->
    %using true matching pattern
    MyList = [{3,3},{3,2},{3,1},{3,0},{2,2},{1,1},{2,0},{2,1},{1,0},{0,0}],
    true = false == pr2_R:isRing(MyList).


flip_Case_1_test() ->
    %using true matching pattern
    MyList = [{2,1},{1,1},{1,0},{0,0},{2,0},{2,2}],
    true = [{2,1},{1,1},{1,0},{0,0},{0,2},{2,2}] == pr2_R:flip(MyList).

flip_Case_2_test() ->
    %using true matching pattern
    MyList = [{4,1},{1,1},{1,0},{0,0},{2,0},{2,1},{1,3},{3,3},{0,3},{0,4},{4,4},{2,4},{2,2},{3,2},{3,4}],
    true = [{4,1},{1,1},{1,0},{0,0},{0,2},{2,1},{1,3},{3,3},{3,0},{0,4},{4,4},{4,2},{2,2},{2,3},{3,4}] == pr2_R:flip(MyList).

solution_odd_test() ->
    true = [] == pr2_R:solution(3).

listAsString_1_test() ->
    MyList = [{2,2},{2,1},{2,0},{1,1},{1,0},{0,0}],
    true = string:equal("[ {2, 2}, {2, 1}, {2, 0}, {1, 1}, {1, 0}, {0, 0} ]", pr2_R:listAsString(MyList)) == true.

listAsString_2_test() ->
    MyList = [],
    true = string:equal("[]", pr2_R:listAsString(MyList)) == true.

%driver_test() ->
    %true = "[{2,0},{2,2},{2,1},{1,1},{1,0},{0,0}]" == pr2_R:driver(fun listAsString/1, fun solution/1, 2).