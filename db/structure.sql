CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "description" varchar NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE TABLE "snippets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar NOT NULL, "content" varchar NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "category_id" integer NOT NULL, "user_id" integer NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar NOT NULL, "auth_token" varchar, "password_digest" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "nickname" varchar NOT NULL);
CREATE INDEX "index_categories_on_title" ON "categories" ("title");
CREATE INDEX "index_snippets_on_category_id" ON "snippets" ("category_id");
CREATE INDEX "index_snippets_on_user_id" ON "snippets" ("user_id");
CREATE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20150724214944');

INSERT INTO schema_migrations (version) VALUES ('20150725081228');

INSERT INTO schema_migrations (version) VALUES ('20150725083228');

INSERT INTO schema_migrations (version) VALUES ('20150728235813');

INSERT INTO schema_migrations (version) VALUES ('20150729000402');

INSERT INTO schema_migrations (version) VALUES ('20150730014136');

INSERT INTO schema_migrations (version) VALUES ('20150730014410');

INSERT INTO schema_migrations (version) VALUES ('20150730214343');

INSERT INTO schema_migrations (version) VALUES ('20150730222639');

INSERT INTO schema_migrations (version) VALUES ('20150731070625');

INSERT INTO schema_migrations (version) VALUES ('20150731070837');

