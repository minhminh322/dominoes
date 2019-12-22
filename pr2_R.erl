% Minh Phan
% Project 2 - TCSS 380 Spring 2019
% 6/7/2019

-module(pr2_R).
-export([dominoes/1, giveRandom/1, isRing/1, flip/1, solution/1, listAsString/1, driver/3, myTest/0]).


% Given an integer, 
% Returns a list of tuples containing all the tiles in the set of double-N dominoes
dominoes(N) -> createList(N, 0, []).

% Base case when N hit 0.
createList(N, _, ListofTuples) when N < 0 -> ListofTuples;

createList(N, Acc, ListofTuples) when Acc =< N ->
    createList(N, Acc + 1, ListofTuples ++ [{N, N-Acc}]);

createList(N, Acc, ListofTuples) when Acc > N ->
    createList(N - 1, 0, ListofTuples).


% Given a list of tuples, returns randomly assembled list of tuples.
giveRandom(ListofTuples) -> 

    % Random a tuple in the list with rand:uniform() that take a randomed index of the list.
    RanTuple = [lists:nth(rand:uniform(length(ListofTuples)),ListofTuples)],

    % Create a List that hold the randomed tuple, while eliminate what already used in the given List.
    headHelper(ListofTuples -- RanTuple, RanTuple, RanTuple).

    % Picks a random initial starting node {StartF, StartB}, then the next random tile may be either of the tiles that
    % contain StartF or StartB.
    headHelper(ListofTuples, [{StartF, StartB}], Head) ->            
            [{Front,Back}] = [lists:nth(rand:uniform(length(ListofTuples)),ListofTuples)],
            % Set the matched tuple side equal -1, so the remainning side is going to be chosen to compare for next random tile.
            case [{Front, Back}] of 
                [{StartF, _}] -> nextHelper(ListofTuples -- [{Front, Back}], [{-1, Back}], Head ++ [{Front, Back}]);
                [{StartB, _}] -> nextHelper(ListofTuples -- [{Front, Back}], [{-1, Back}], Head ++ [{Front, Back}]);
                [{_, StartF}] -> nextHelper(ListofTuples -- [{Front, Back}], [{Front, -1}], Head ++ [{Front, Back}]);
                [{_, StartB}] -> nextHelper(ListofTuples -- [{Front, Back}], [{Front, -1}], Head ++ [{Front, Back}]);
                _ -> headHelper(ListofTuples, [{StartF, StartB}], Head)
            end.    
    
    % Base case 1: Return Assembled List when no element in the given List.
    nextHelper([], _, AssembledList) -> AssembledList;

    % Picks randomly another tuple that matches the preceding one.
    nextHelper(ListofTuples, [{CurrentF, CurrentB}], AssembledList) ->
        [{Front, Back}] = [lists:nth(rand:uniform(length(ListofTuples)),ListofTuples)],
        
        % Create Temporary list where hold the given list but without Current tuple.
        TempList = ListofTuples -- [{CurrentF, CurrentB}],
        
        case [{CurrentF, CurrentB}]  of 
            [{-1, _}] ->

                % Match List using List comprehension to get matched tile in the list.
                MatchListBack = [{F, B} || {F, B} <- TempList, (F == CurrentB) or (B == CurrentB)],
                case MatchListBack of 
                    [] -> AssembledList;  % Base case 2: Return Assembled List when the given List has no more matches.
                    _ ->
                case [{Front, Back}] of
                    [{CurrentB, _}] -> 
                        nextHelper(ListofTuples -- [{Front, Back}], [{-1, Back}], AssembledList ++ [{Front, Back}]);
                    [{_,CurrentB}] -> 
                        nextHelper(ListofTuples -- [{Front, Back}], [{Front, -1}], AssembledList ++ [{Front, Back}]);
                    _ -> 
                        nextHelper(ListofTuples, [{CurrentF, CurrentB}], AssembledList)
                end
            end;

                
            [{_, -1}] -> 
                    MatchListFront = [{F, B} || {F, B} <- TempList, (F == CurrentF) or (B == CurrentF)],
                    case MatchListFront of 
                        [] -> AssembledList; % Base case 2: Return Assembled List when the given List has no more matches.
                        _ ->
                    case [{Front, Back}] of
                        [{CurrentF, _}] -> 
                            nextHelper(ListofTuples -- [{Front, Back}], [{-1, Back}], AssembledList ++ [{Front, Back}]);
                        [{_,CurrentF}] -> 
                            nextHelper(ListofTuples -- [{Front, Back}], [{Front, -1}], AssembledList ++ [{Front, Back}]);
                        _ -> 
                            nextHelper(ListofTuples, [{CurrentF, CurrentB}], AssembledList)
                    end
                end
        end.


% Given a list of tuples, Returns true if tuples form a ring and 
% all tiles from a double-N domino set have been used, or false otherwise.
isRing(MyList) ->
    {E1,E2} = lists:max(MyList),
    case E1 > E2 of 
        true -> DoubleN = dominoHelper(E1);
        false -> DoubleN = dominoHelper(E2)
    end,
    case DoubleN == length(MyList) of 
        true -> checkFirstLast(MyList);
        false -> false
    end.


% Calculate the double-N domino set of tiles,
% Return true if total is even, otherwise false.
dominoHelper(N) ->
    case N rem 2 == 0 of 
        true -> (N+1)*((N+2)/2);
        false -> false
    end.

% Check the first and last dominoes,
% Return true if match, otherwise false.    
checkFirstLast(List) ->
        {F1,F2} = lists:nth(1, List),
        {L1,L2} = lists:last(List),
        case {F1,F2} of 
                {L1,_} -> true;
                {_,L1} -> true;
                {L2,_} -> true;
                {_,L2} -> true
            end.


% Given a list of tuples that form a circular train, 
% Returns a list with tiles that are flipped where appropriate to make the loop self-evident.
flip(MyList) -> checkHead(MyList, []).

% Check the first 2 tuples in the given list to decide which side we are going to match next.
checkHead([{F1,F2} | [{S1,S2} | Rest]], FlipList) ->
        case [{F1, F2}] of 
                [{S1, _}] -> checkTail(Rest, FlipList ++ [{F1,F2},{S1,S2}]);
                [{S2, _}] -> checkTail(Rest, FlipList ++ [{F1,F2},{S2,S1}]);
                [{_, S1}] -> checkTail(Rest, FlipList ++ [{F1,F2},{S1,S2}]);
                [{_, S2}] -> checkTail(Rest, FlipList ++ [{F1,F2},{S2,S1}])
            end. 

% Recursively check the rest of list, if no match, swap two elements in the tuple.
checkTail([], FlipList) -> FlipList;
checkTail(MyList, FlipList) -> 
    {F1,F2} = lists:last(FlipList),
    {M1,M2} = lists:nth(1, MyList),
    case {F1,F2} of 
        {_,M1} -> checkTail(MyList -- [{M1,M2}], FlipList ++ [{M1,M2}]);
        {_,M2} -> checkTail(MyList -- [{M1,M2}], FlipList ++ [{M2,M1}])
    end.


%  Given an integer, generates a solution 
solution(N) ->
    case N rem 2 == 0 of
        true -> 
            solutionHelper(fun flip/1,fun isRing/1,
            fun giveRandom/1,fun dominoes/1, N);
        false -> []
    end.

solutionHelper( F, R, G ,D, N) -> X = G(D(N)),
    case R(X) of 
        true -> F(X);
        false -> solution(N)
    end.

% Given a list of tuples, returns a string representing that list
listAsString([]) -> X = [], lists:flatten(io_lib:format("~p", [X]));
listAsString(MyList) -> formatHead(MyList, []).

formatHead([H|T], ListString) ->
    X = element(1,H),
    Y = element(2, H), 
    StringX = lists:flatten(io_lib:format(" {~p,", [X])),
    StringY = lists:flatten(io_lib:format(" ~p}", [Y])),

    formatRest(T, ListString ++ StringX ++ StringY).

formatRest([], ListString) -> Str1 = " ",
                            [$[] ++ ListString ++ Str1 ++ [$]];
formatRest([H|T], ListString) ->
    X = element(1,H),
    Y = element(2, H), 
    StringX = lists:flatten(io_lib:format(", {~p,", [X])),
    StringY = lists:flatten(io_lib:format(" ~p}", [Y])),
    formatRest(T, (ListString ++ StringX ++ StringY)).


% Given listAsString and solution functions, as well as N - the initial highest number 
% of dots for the set, returns a string representing a solution to the program.
driver(F1, F2, N) ->
    F1(F2(N)).

myTest() -> driver(fun listAsString/1, fun solution/1, 4).
