:- encoding(utf8).

% VetIA — sistema experto veterinario en SWI-Prolog.
%
% Cargar desde la carpeta del proyecto:
%   ?- consult('Vetia.pl').
%   ?- diagnosticar([fiebre, tos, mioclonias]).
%   ?- diagnosticar([presente(vomito), ausente(fiebre)]).
%   ?- consult('pruebas.pl'), run_tests.

:- prolog_load_context(directory, Dir),
   forall(member(Base, [conocimiento, reglas, motor]),
          (   absolute_file_name(Base, Path,
                                 [relative_to(Dir), extensions([pl]), access(read)]),
              consult(Path)
          )).
