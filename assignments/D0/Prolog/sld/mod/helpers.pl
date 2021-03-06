% -----------------------------------------------------------------------------+
%                                                                              |
%  helpers.pl                                                                  |
%                                                                              |
%  This file is part of "sld-tree-generator". (this program)                   |
%                                                                              |
% -----------------------------------------------------------------------------+
%                                                                              |
%  Copyright (C) 2016 by Andreas Pollhammer                                    |
%                                                                              |
%  Email: apoll500@gmail.com                                                   |
%  Web:   http://www.andreaspollhammer.com                                     |
%                                                                              |
% -----------------------------------------------------------------------------+
%                                                                              |
%  Licensed under GPLv3:                                                       |
%                                                                              |
%  This program is free software: you can redistribute it and/or modify        |
%  it under the terms of the GNU General Public License as published by        |
%  the Free Software Foundation, either version 3 of the License, or           |
%  (at your option) any later version.                                         |
%                                                                              |
%  This program is distributed in the hope that it will be useful,             |
%  but WITHOUT ANY WARRANTY; without even the implied warranty of              |
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
%  GNU General Public License for more details.                                |
%                                                                              |
%  You should have received a copy of the GNU General Public License           |
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
%                                                                              |
% -----------------------------------------------------------------------------+
:-module(helpers,[varlist/2,
          solve/1,
          lastElementOfList/2,
          listunify/2,
          list_to_atomiclist/2,
          listBindUnify/4,
          solution/3]).

% ------------------------------------------------------------------------------
% (1)
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% varlist/2
% ------------------------------------------------------------------------------
% varlist(+Bidings,-Variables)
% Bindings is a list of Variable-Name Bindings as generated by atom_to_term/3.
% Variables is a List of Variable-Names extracted from Bindings.
% ------------------------------------------------------------------------------
varlist([],[]).
varlist([B|Bs],[L|Ls]):-
        B=(L=_),
        varlist(Bs,Ls).

% ------------------------------------------------------------------------------
% Aufrufen aller Eintraege in einer Liste und Listen von Listen.
% ------------------------------------------------------------------------------
solve([]).
solve([[]]).
solve([[]|Gs]):-
        solve(Gs).
solve([[GA|GAs]|Gs]):-
        solve(GA),
        solve(GAs),
        solve(Gs).
solve([G|Gs]):-
        call(G),
        solve(Gs).
solve(G):-
        call(G).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
listunify([],[]).
listunify([A|As],[B|Bs]):-
    A=B,
    listunify(As,Bs).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
listBindUnify([],[],[],[]).
listBindUnify([L|Ls],[_M|Ms],[BV=_BI|Bs],RL):-
    varAtom_to_term(BV,VT),
    R=(VT=L),
    listBindUnify(Ls,Ms,Bs,Rs),
    RL=[R|Rs].
    
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
list_to_atomiclist([],[]).
list_to_atomiclist([L|Ls],AL):-
    term_to_atom(L,A),
    list_to_atomiclist(Ls,As),
    AL=[A|As].

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
varTerm_to_atom(variable(Name,Index),A):-
    atomic_list_concat(['VARIABLE__',Name,'_',Index],A).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
varAtom_to_term(A,variable(Name,Index)):-
    atomic_list_concat(['VARIABLE',_|Ls],'_',A),
    append(OName0,[IndexA],Ls),
    atom_to_term(IndexA,Index,_),
    atomic_list_concat(OName0,'_',Name).

%fillin(Term,[],Term2):-
%fillin(Term,[U|Us],Term2):-
%fillin2(Term,Name=Value,Term2):-
    
% ------------------------------------------------------------------------------
% Manipulation von Listen
% ------------------------------------------------------------------------------
lastElementOfList([LastElement],LastElement).
lastElementOfList([_|Ls],LastElement):-
        lastElementOfList(Ls,LastElement).

% ------------------------------------------------------------------------------
% Eine Loesung zusammensetzen
% ------------------------------------------------------------------------------
solution(Variables,Substitutions,Result):-
        to_unbounded_term([Variables,Substitutions],[UV,US]),
        solve(US),
        listToSubstList(Variables,UV,Result).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
listToSubstList([],[],[]).
listToSubstList([A|As],[B|Bs],[S|Ss]):-
        S=(A=B),
        listToSubstList(As,Bs,Ss).
