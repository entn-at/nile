#pragma once
#include <vector>
#include <string>
#include <fstream>
#include <cassert>
#include "kbest_hypothesis.h"
using namespace std;

class KbestList {
public:
  virtual ~KbestList() = 0;
  virtual bool NextSet(vector<KbestHypothesis>& out) = 0;
  virtual void Reset() = 0;
};

class SimpleKbestList : public KbestList {
public:
  explicit SimpleKbestList(string filename);
  ~SimpleKbestList();
  bool NextSet(vector<KbestHypothesis>& out);
  void Reset();
private:
  void Cleanup();
  KbestHypothesis* next_hypothesis;
  string current_sent_id;
  ifstream* input_file;
  string filename;
};

class KbestListInRam : public KbestList {
public:
  explicit KbestListInRam(string filename);
  ~KbestListInRam();
  bool NextSet(vector<KbestHypothesis>& out);
  void Reset();
private:
  bool done_loading;
  SimpleKbestList simple_kbest;
  vector<vector<KbestHypothesis> > hypotheses;
  vector<vector<KbestHypothesis> >::iterator it;
};

