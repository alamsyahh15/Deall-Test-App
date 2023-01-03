// To parse this JSON data, do
//
//     final issueResponse = issueResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_github/model/users_response.dart';

IssueResponse issueResponseFromJson(String str) =>
    IssueResponse.fromJson(json.decode(str));

String issueResponseToJson(IssueResponse data) => json.encode(data.toJson());

class IssueResponse {
  IssueResponse({
    required this.totalCount,
    required this.incompleteResults,
    this.items,
  });

  int totalCount;
  bool incompleteResults;
  List<Issue>? items;

  factory IssueResponse.fromJson(Map<String, dynamic> json) => IssueResponse(
        totalCount: json["total_count"],
        incompleteResults: json["incomplete_results"],
        items: json["items"] == null
            ? null
            : List<Issue>.from(json["items"].map((x) => Issue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "incomplete_results": incompleteResults,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Issue {
  Issue({
    this.url,
    this.repositoryUrl,
    this.labelsUrl,
    this.commentsUrl,
    this.eventsUrl,
    this.htmlUrl,
    this.id,
    this.nodeId,
    this.number,
    this.title,
    this.user,
    this.labels,
    this.state,
    this.locked,
    this.assignee,
    this.assignees,
    this.milestone,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.authorAssociation,
    this.activeLockReason,
    this.draft,
    this.pullRequest,
    this.body,
    this.reactions,
    this.timelineUrl,
    this.performedViaGithubApp,
    this.stateReason,
    this.score,
  });

  String? url;
  String? repositoryUrl;
  String? labelsUrl;
  String? commentsUrl;
  String? eventsUrl;
  String? htmlUrl;
  int? id;
  String? nodeId;
  int? number;
  String? title;
  User? user;
  List<Label>? labels;
  String? state;
  bool? locked;
  User? assignee;
  List<User>? assignees;
  dynamic milestone;
  int? comments;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic closedAt;
  AuthorAssociation? authorAssociation;
  dynamic activeLockReason;
  bool? draft;
  PullRequest? pullRequest;
  String? body;
  Reactions? reactions;
  String? timelineUrl;
  dynamic performedViaGithubApp;
  dynamic stateReason;
  double? score;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        url: json["url"],
        repositoryUrl: json["repository_url"],
        labelsUrl: json["labels_url"],
        commentsUrl: json["comments_url"],
        eventsUrl: json["events_url"],
        htmlUrl: json["html_url"],
        id: json["id"],
        nodeId: json["node_id"],
        number: json["number"],
        title: json["title"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        labels: json["labels"] == null
            ? null
            : List<Label>.from(json["labels"].map((x) => Label.fromJson(x))),
        state: json["state"],
        locked: json["locked"],
        assignee:
            json["assignee"] == null ? null : User.fromJson(json["assignee"]),
        assignees: json["assignees"] == null
            ? null
            : List<User>.from(json["assignees"].map((x) => User.fromJson(x))),
        milestone: json["milestone"],
        comments: json["comments"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        closedAt: json["closed_at"],
        authorAssociation: json["author_association"] == null
            ? null
            : authorAssociationValues.map[json["author_association"]],
        activeLockReason: json["active_lock_reason"],
        draft: json["draft"],
        pullRequest: json["pull_request"] == null
            ? null
            : PullRequest.fromJson(json["pull_request"]),
        body: json["body"],
        reactions: json["reactions"] == null
            ? null
            : Reactions.fromJson(json["reactions"]),
        timelineUrl: json["timeline_url"],
        performedViaGithubApp: json["performed_via_github_app"],
        stateReason: json["state_reason"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "repository_url": repositoryUrl,
        "labels_url": labelsUrl,
        "comments_url": commentsUrl,
        "events_url": eventsUrl,
        "html_url": htmlUrl,
        "id": id,
        "node_id": nodeId,
        "number": number,
        "title": title,
        "user": user == null ? null : user!.toJson(),
        "labels": labels == null
            ? null
            : List<dynamic>.from(labels!.map((x) => x.toJson())),
        "state": state,
        "locked": locked,
        "assignee": assignee == null ? null : assignee!.toJson(),
        "assignees": assignees == null
            ? null
            : List<dynamic>.from(assignees!.map((x) => x.toJson())),
        "milestone": milestone,
        "comments": comments,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "closed_at": closedAt,
        "author_association": authorAssociation == null
            ? null
            : authorAssociationValues.reverse![authorAssociation],
        "active_lock_reason": activeLockReason,
        "draft": draft,
        "pull_request": pullRequest == null ? null : pullRequest!.toJson(),
        "body": body,
        "reactions": reactions == null ? null : reactions!.toJson(),
        "timeline_url": timelineUrl,
        "performed_via_github_app": performedViaGithubApp,
        "state_reason": stateReason,
        "score": score,
      };
}

enum Type { USER, BOT }

final typeValues = EnumValues({"Bot": Type.BOT, "User": Type.USER});

enum AuthorAssociation { NONE, OWNER, CONTRIBUTOR }

final authorAssociationValues = EnumValues({
  "CONTRIBUTOR": AuthorAssociation.CONTRIBUTOR,
  "NONE": AuthorAssociation.NONE,
  "OWNER": AuthorAssociation.OWNER
});

class Label {
  Label({
    this.id,
    this.nodeId,
    this.url,
    this.name,
    this.color,
    this.labelDefault,
    this.description,
  });

  int? id;
  String? nodeId;
  String? url;
  String? name;
  String? color;
  bool? labelDefault;
  String? description;

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"],
        nodeId: json["node_id"],
        url: json["url"],
        name: json["name"],
        color: json["color"],
        labelDefault: json["default"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "node_id": nodeId,
        "url": url,
        "name": name,
        "color": color,
        "default": labelDefault,
        "description": description,
      };
}

class PullRequest {
  PullRequest({
    this.url,
    this.htmlUrl,
    this.diffUrl,
    this.patchUrl,
    this.mergedAt,
  });

  String? url;
  String? htmlUrl;
  String? diffUrl;
  String? patchUrl;
  dynamic mergedAt;

  factory PullRequest.fromJson(Map<String, dynamic> json) => PullRequest(
        url: json["url"],
        htmlUrl: json["html_url"],
        diffUrl: json["diff_url"],
        patchUrl: json["patch_url"],
        mergedAt: json["merged_at"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "html_url": htmlUrl,
        "diff_url": diffUrl,
        "patch_url": patchUrl,
        "merged_at": mergedAt,
      };
}

class Reactions {
  Reactions({
    this.url,
    this.totalCount,
    this.the1,
    this.reactions1,
    this.laugh,
    this.hooray,
    this.confused,
    this.heart,
    this.rocket,
    this.eyes,
  });

  String? url;
  int? totalCount;
  int? the1;
  int? reactions1;
  int? laugh;
  int? hooray;
  int? confused;
  int? heart;
  int? rocket;
  int? eyes;

  factory Reactions.fromJson(Map<String, dynamic> json) => Reactions(
        url: json["url"],
        totalCount: json["total_count"],
        the1: json["+1"],
        reactions1: json["-1"],
        laugh: json["laugh"],
        hooray: json["hooray"],
        confused: json["confused"],
        heart: json["heart"],
        rocket: json["rocket"],
        eyes: json["eyes"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "total_count": totalCount,
        "+1": the1,
        "-1": reactions1,
        "laugh": laugh,
        "hooray": hooray,
        "confused": confused,
        "heart": heart,
        "rocket": rocket,
        "eyes": eyes,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
