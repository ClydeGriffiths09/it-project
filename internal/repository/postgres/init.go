package postgres

import (
	"context"
	"fmt"
	"net"
	"net/url"
	"time"

	"project/internal/config"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func New(cfg *config.PostgresConfig) (*sqlx.DB, error) {
	dsn := &url.URL{Scheme: "postgres", User: url.UserPassword(cfg.User, cfg.Password), Host: net.JoinHostPort(cfg.Host, cfg.Port), Path: "/" + cfg.DBName}
	query := dsn.Query()
	query.Set("sslmode", cfg.SSLMode)
	dsn.RawQuery = query.Encode()
	db, err := sqlx.Open("postgres", dsn.String())
	if err != nil {
		return nil, fmt.Errorf("postgres.NewPostgresConnect.open: %w", err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := db.PingContext(ctx); err != nil {
		_ = db.Close()
		return nil, fmt.Errorf("postgres.NewPostgresConnect.ping: %w", err)
	}
	return db, nil
}
