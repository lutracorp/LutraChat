package database

import (
	"context"
)

// AddOne pushes single entity to database.
func AddOne[T any](ctx context.Context, entity *T) error {
	return DB.WithContext(ctx).Create(&entity).Error
}

// AddMany pushes multiple entities to database.
func AddMany[T any](ctx context.Context, entities *[]T) error {
	return DB.WithContext(ctx).Create(&entities).Error
}

// GetOne returns single entity from database which matches passed params.
func GetOne[T any](ctx context.Context, query interface{}, args ...interface{}) (*T, error) {
	var entity T

	if err := DB.WithContext(ctx).Where(query, args...).First(&entity).Error; err != nil {
		return nil, err
	}

	return &entity, nil
}

// GetMany returns multiple entities from database that matches passed params.
func GetMany[T any](ctx context.Context, query interface{}, args ...interface{}) (*[]T, error) {
	var entities []T

	if err := DB.WithContext(ctx).Where(query, args...).Find(&entities).Error; err != nil {
		return nil, err
	}

	return &entities, nil
}

// UpdateOne updates single entity.
func UpdateOne[T any](ctx context.Context, entity *T) error {
	return DB.WithContext(ctx).Save(&entity).Error
}

// UpdateMany updates multiple entities.
func UpdateMany[T any](ctx context.Context, entities *[]T) error {
	return DB.WithContext(ctx).Save(&entities).Error
}

// DeleteOne removes single entity from database.
func DeleteOne[T any](ctx context.Context, entity *T) error {
	return DB.WithContext(ctx).Delete(&entity).Error
}

// DeleteMany removes multiple entities from database.
func DeleteMany[T any](ctx context.Context, entities *[]T) error {
	return DB.WithContext(ctx).Delete(&entities).Error
}
