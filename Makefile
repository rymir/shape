REBAR=`which rebar`
DIALYZER=`which dialyzer`
RELX=`which relx`

all: deps compile

deps:
	@$(REBAR) get-deps

compile: deps
	@$(REBAR) compile

app.plt:
	@$(DIALYZER) --build_plt --output_plt app.plt --apps erts kernel stdlib crypto

dialyze: app.plt compile
	@$(DIALYZER) -q --plt app.plt apps/*/ebin -Wunmatched_returns \
		-Werror_handling -Wrace_conditions -Wno_undefined_callbacks

test: compile
	@$(REBAR) -r -v -DTEST eunit skip_deps=true verbose=0
	ct_run -dir apps/*/itest -pa ebin -verbosity 0 -logdir .ct/logs -erl_args +K true +A 10

doc:
	@$(REBAR) -r doc skip_deps=true	

validate: dialyze test

release: clean validate
	@$(RELX) release tar

relup: clean validate
	@$(RELX) release relup tar

clean:
	@$(RM) -rf deps/
	@$(REBAR) -r clean

.PHONY: all deps compile dialyze test doc validate release relup
