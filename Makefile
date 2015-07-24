CC=g++
#CNN_DIR = /Users/austinma/git/cnn/
#CNN_DIR = /home/austinma/git/cnn
CNN_DIR = /home/austinma/git/ws15mt-cnn
#CNN_DIR=/export/a04/gkumar/code/cnn/
#CNN_DIR=/Users/gaurav/Projects/cnn/
#EIGEN = /Users/austinma/git/eigen
EIGEN = /opt/tools/eigen-dev/
#EIGEN=/export/a04/gkumar/code/eigen/
#EIGEN=/Users/gaurav/Projects/eigen/
CNN_BUILD_DIR=$(CNN_DIR)/build
INCS=-I$(CNN_DIR) -I$(CNN_BUILD_DIR) -I$(EIGEN)
LIBS=-L$(CNN_BUILD_DIR)/cnn/
FINAL=-lcnn -lboost_regex -lboost_serialization -lboost_program_options
#CFLAGS=-std=c++11 -Ofast -march=native -pipe
CFLAGS=-std=c++11 -O0 -g -DDEBUG -pipe
BINDIR=bin
OBJDIR=obj
SRCDIR=src

.PHONY: clean
all: make_dirs $(BINDIR)/rerank $(BINDIR)/pro_ebleu

make_dirs:
	mkdir -p $(OBJDIR)
	mkdir -p $(BINDIR)

clean:
	rm -rf $(BINDIR)/*
	rm -rf $(OBJDIR)/*

$(OBJDIR)/dataview.o: $(SRCDIR)/dataview.cc $(SRCDIR)/gaurav.h $(SRCDIR)/kbestlist.h $(SRCDIR)/dataview.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/context.o: $(SRCDIR)/context.cc $(SRCDIR)/context.h $(SRCDIR)/utils.h $(SRCDIR)/kbest_converter.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/reranker.o: $(SRCDIR)/reranker.cc $(SRCDIR)/reranker.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/utils.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/kbestlist.o: $(SRCDIR)/kbestlist.cc $(SRCDIR)/kbestlist.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/utils.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/utils.o: $(SRCDIR)/utils.cc $(SRCDIR)/utils.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/kbest_hypothesis.o: $(SRCDIR)/kbest_hypothesis.cc $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/utils.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/pro.o: $(SRCDIR)/pro.cc $(SRCDIR)/utils.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/pair_sampler.h $(SRCDIR)/kbestlist.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/pro_ebleu.o: $(SRCDIR)/pro_ebleu.cc $(SRCDIR)/utils.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/kbestlist.h $(SRCDIR)/reranker.h $(SRCDIR)/kbest_converter.h $(SRCDIR)/feature_extractor.h $(SRCDIR)/gaurav.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/pro_gaurav.o: $(SRCDIR)/pro_gaurav.cc $(SRCDIR)/utils.h $(SRCDIR)/reranker.h $(SRCDIR)/gaurav.h $(SRCDIR)/kbest_converter.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/context.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/rerank.o: $(SRCDIR)/rerank.cc $(SRCDIR)/utils.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/pair_sampler.h	$(SRCDIR)/kbest_converter.h $(SRCDIR)/kbestlist.h $(SRCDIR)/reranker.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/gaurav.o: $(SRCDIR)/gaurav.cc $(SRCDIR)/utils.h $(SRCDIR)/gaurav.h $(SRCDIR)/context.h $(SRCDIR)/kbest_converter.h  $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/context.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/kbest_converter.o: $(SRCDIR)/kbest_converter.cc $(SRCDIR)/kbest_converter.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/utils.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/feature_extractor.o: $(SRCDIR)/feature_extractor.cc $(SRCDIR)/feature_extractor.h $(SRCDIR)/kbest_converter.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/utils.h $(SRCDIR)/kbestlist.h $(SRCDIR)/gaurav.h $(SRCDIR)/context.h $(SRCDIR)/dataview.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(OBJDIR)/sandbox.o: $(SRCDIR)/sandbox.cc $(SRCDIR)/kbest_converter.h $(SRCDIR)/kbest_hypothesis.h $(SRCDIR)/utils.h
	g++ -c $(CFLAGS) $(INCS) $< -o $@

$(BINDIR)/pro: $(OBJDIR)/pro.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/utils.o $(OBJDIR)/kbestlist.o	
	g++ $(LIBS) $^ -o $@ $(FINAL)
	
$(BINDIR)/pro_ebleu: $(OBJDIR)/pro_ebleu.o $(OBJDIR)/kbestlist.o $(OBJDIR)/utils.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/reranker.o $(OBJDIR)/kbest_converter.o $(OBJDIR)/feature_extractor.o $(OBJDIR)/dataview.o $(OBJDIR)/gaurav.o $(OBJDIR)/context.o
	g++ $(LIBS) $^ -o $@ $(FINAL)

$(BINDIR)/pro_gaurav: $(OBJDIR)/pro_gaurav.o $(OBJDIR)/gaurav.o $(OBJDIR)/utils.o $(OBJDIR)/reranker.o $(OBJDIR)/kbest_converter.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/kbestlist.o $(OBJDIR)/context.o
	g++ $(LIBS) $^ -o $@ $(FINAL)

$(BINDIR)/rerank: $(OBJDIR)/rerank.o $(OBJDIR)/kbestlist.o $(OBJDIR)/utils.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/reranker.o $(OBJDIR)/kbest_converter.o $(OBJDIR)/feature_extractor.o $(OBJDIR)/dataview.o $(OBJDIR)/gaurav.o $(OBJDIR)/context.o
	g++ $(LIBS) $^ -o $@ $(FINAL)

$(BINDIR)/sandbox: $(OBJDIR)/sandbox.o $(OBJDIR)/kbest_hypothesis.o $(OBJDIR)/kbest_converter.o $(OBJDIR)/utils.o
	g++ $(LIBS) $^ -o $@ $(FINAL)
