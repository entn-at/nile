#include <map>
#include <string>
#include <vector>
#include "utils.h"

using namespace std;

struct KbestHypothesis {
  string sentence_id;
  string sentence;
  map<string, double> features;
  double metric_score;

  static KbestHypothesis parse(string input);
};

KbestHypothesis KbestHypothesis::parse(string input) {
  vector<string> parts = tokenize(input, "|||");
  parts = strip(parts);
  string sentence_id = parts[0];
  string sentence = parts[1];
  map<string, double> features = parse_feature_string(parts[2]);
  double metric_score = std::stod(parts[parts.size() - 1]);
  return {sentence_id, sentence, features, metric_score};
}

struct FastKbestHypothesis {
  string sentence_id;
  string sentence;
  unordered_map<unsigned, double> features;
  double metric_score;

  static FastKbestHypothesis parse(string input, map<string, unsigned>& feat2id);
};

FastKbestHypothesis FastKbestHypothesis::parse(string input, map<string, unsigned>& feat2id) {
  vector<string> parts = tokenize(input, "|||");
  parts = strip(parts);
  string sentence_id = parts[0];
  string sentence = parts[1];
  map<string, double> feature_map = parse_feature_string(parts[2]);
  unordered_map<unsigned, double> features;
  for (auto it = feature_map.begin(); it != feature_map.end(); it++) {
    if (feat2id.find(it->first) != feat2id.end()) {
      features[feat2id[it->first]] = it->second;
    }
  }
  double metric_score = std::stod(parts[parts.size() - 1]);
  return {sentence_id, sentence, features, metric_score};
}

