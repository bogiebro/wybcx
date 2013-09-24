exports.triggerMigrate = function(sequelize, name, expr) {
	sequelize.query("DO $$BEGIN IF NOT EXISTS (SELECT 1 \
		FROM information_schema.triggers WHERE trigger_name = ? ) \
		THEN CREATE TRIGGER " + name + "\n" + expr + "\n END IF;\n\
		END$$;", null, {raw: true}, [name])
}

exports.indexMigrate = function(sequelize, name, expr) {
	sequelize.query("DO $$ BEGIN IF NOT EXISTS (SELECT 1 \
		FROM pg_class c WHERE c.relname = ? ) \
		THEN CREATE INDEX " + name + "\n" + expr + "\n END IF;\n\
		END$$;", null, {raw: true}, [name])
}
