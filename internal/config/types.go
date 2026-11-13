package config

import "time"

type Config struct {
	App        AppConfig        `yaml:"app"`
	Admin      AdminConfig      `yaml:"admin"`
	Postgres   PostgresConfig   `yaml:"postgres"`
	Redis      RedisConfig      `yaml:"redis"`
	RabbitMQ   RabbitMQConfig   `yaml:"rabbitmq"`
	ClickHouse ClickHouseConfig `yaml:"clickhouse"`
	Minio      MinioConfig      `yaml:"minio"`
}

type AppConfig struct {
	Port string `yaml:"port"`
}

type AdminConfig struct {
	SessionTTL time.Duration `yaml:"session_ttl"`
}

type PostgresConfig struct {
	Host     string `yaml:"host"`
	Port     string `yaml:"port"`
	SSLMode  string `yaml:"sslmode"`
	User     string `yaml:"-"`
	Password string `yaml:"-"`
	DBName   string `yaml:"-"`
}

type RedisConfig struct {
	Host     string `yaml:"host"`
	Port     string `yaml:"port"`
	Password string `yaml:"-"`
}

type RabbitMQConfig struct {
	Host     string `yaml:"host"`
	Port     string `yaml:"port"`
	User     string `yaml:"-"`
	Password string `yaml:"-"`
}

type ClickHouseConfig struct {
	Host     string `yaml:"host"`
	Port     string `yaml:"port"`
	DBName   string `yaml:"-"`
	User     string `yaml:"-"`
	Password string `yaml:"-"`
}

type MinioConfig struct {
	Host       string `yaml:"host"`
	Port       string `yaml:"port"`
	BucketName string `yaml:"bucket"`
	UseSSL     bool   `yaml:"use_ssl"`
	User       string `yaml:"-"`
	Password   string `yaml:"-"`
}
