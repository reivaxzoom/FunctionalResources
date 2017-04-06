%% @author Xavier
%% @doc @todo Add description to adm.


-module(adm).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).


sysinfo()->
SchedId      = erlang:system_info(scheduler_id),
SchedNum     = erlang:system_info(schedulers),
ProcCount    = erlang:system_info(process_count),
ProcLimit    = erlang:system_info(process_limit),
ProcMemUsed  = erlang:memory(processes_used),
ProcMemAlloc = erlang:memory(processes),
MemTot       = erlang:memory(total),
io:format("abormal termination: "
          "~n   Scheduler id:                         ~p"
          "~n   Num scheduler:                        ~p"
          "~n   Process count:                        ~p"
          "~n   Process limit:                        ~p"
          "~n   Memory used by erlang processes:      ~p"
          "~n   Memory allocated by erlang processes: ~p"
          "~n   The total amount of memory allocated: ~p"
          ,
          [SchedId, SchedNum, ProcCount, ProcLimit,
           ProcMemUsed, ProcMemAlloc, MemTot]).

main() ->  
  net_kernel:start([procount, shortnames]),
  {_, Hostname} = inet:gethostname(), 
  Remote = lists:concat(['example@node']),
  io:format("status report ~s~n", [Remote]),
  Node = erlang:list_to_atom(Remote),
  MemEts = rpc:call(Node, erlang, memory, [ets]),
  MemBinary = rpc:call(Node, erlang, memory, [binary]),
  MemProc = rpc:call(Node, erlang, memory, [processes]),
  MemProcUsed = rpc:call(Node, erlang, memory, [processes_used]),
  MemAtom = rpc:call(Node, erlang, memory, [atom]),
  MemAtomUsed = rpc:call(Node, erlang, memory, [atom_used]),
  MemCode = rpc:call(Node, erlang, memory, [code]),
  MemUsed = rpc:call(Node, erlang, memory, [total]),
  MemLimit = rpc:call(Node, vm_memory_monitor, get_memory_limit, []),
  ProcUsed = rpc:call(Node, erlang, system_info, [process_count]),
  ProcTotal = rpc:call(Node, erlang, system_info, [process_limit]),
  RunQueue = rpc:call(Node, erlang, statistics, [run_queue]),
  {ContextSwitches, _} = rpc:call(Node, erlang, statistics, [context_switches]),
  io:format("mem_ets: ~w~nmem_binary: ~w~nmem_proc: ~w~nmem_proc_used: ~w~nmem_atom: ~w~nmem_atom_used: ~w~nmem_code: ~w~nmem_used: ~w~nmem_limit: ~w~n", 
            [MemEts, MemBinary, MemProc, MemProcUsed, MemAtom, MemAtomUsed, MemCode, MemUsed, MemLimit]),
  io:format("proc_used: ~w~nproc_limit: ~w~n", [ProcUsed, ProcTotal]),
  io:format("run_queue: ~w~ncontext_switches: ~w~n", [RunQueue, ContextSwitches]).


%% ====================================================================
%% Internal functions
%% ====================================================================



%% File Methods
readfile() ->
    {ok, Device} = file:open(?Str, [read]),
    get_all_lines(Device, []).
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> get_all_lines(Device, Accum ++ [Line])
    end.



