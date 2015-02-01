REBAR=./rebar
RELX=./relx
DIALYZER=$(shell which dialyzer)
ifeq ($(DIALYZER),)
	$(error "Dialyzer not available on this system")
endif

DEPSOLVER_PLT=./.plt

RELEASES = \
	shape \
	shape2

all: deps compile

deps:
	@$(REBAR) get-deps

compile: deps
	@$(REBAR) compile

$(DEPSOLVER_PLT):
	@$(DIALYZER) --output_plt $(DEPSOLVER_PLT) --build_plt \
		--apps erts kernel stdlib crypto public_key -r deps

dialyze: $(DEPSOLVER_PLT) compile
	@$(DIALYZER) --plt $(DEPSOLVER_PLT) --src apps/*/src \
		-Wunmatched_returns -Werror_handling -Wrace_conditions \
		-Wno_undefined_callbacks

test: compile
	@$(REBAR) -r -v -DTEST eunit skip_deps=true verbose=0
	ct_run -dir apps/*/itest -pa ebin -verbosity 0 -logdir .ct/logs \
		-erl_args +K true +A 10

doc:
	@$(REBAR) -r doc skip_deps=true

validate: dialyze test

release: $(addsuffix .release, $(RELEASES))

%.release: clean validate PHONY
	@$(RELX) release -c relx-$*.config tar

relup: clean validate
	@$(RELX) release relup tar

clean:
	@$(REBAR) -r clean

distclean: clean
	@rm $(DEPSOLVER_PLT)
	@rm -rvf ./deps/*

PHONY:
	@true

.PHONY: PHONY all deps compile dialyze test doc validate release relup clean \
	distclean
