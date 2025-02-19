package controller

import (
	"github.com/gofiber/fiber/v2"
	"github.com/lutracorp/foxid-go"
	tknpb "github.com/lutracorp/lutrachat/api/protocol/pkg/token/v1"
	"github.com/lutracorp/lutrachat/internal/pkg/database"
	"github.com/lutracorp/lutrachat/internal/pkg/server/http"
	"github.com/lutracorp/lutrachat/internal/pkg/token"
	"google.golang.org/protobuf/proto"
)

const (
	headerXUserID = "X-User-Id" // Header used to store authenticated user id.
)

// Forward forwards authorization data to proxy.
func Forward(ctx *fiber.Ctx) error {
	header := ctx.Get(fiber.HeaderAuthorization)

	data := &tknpb.TokenData{}
	if err := tknpb.Unmarshal(header, data); err != nil {
		return http.InvalidCredentialsRestrictionError
	}
	if proto.Size(data) == 0 || len(data.Payload) != 16 {
		return http.InvalidCredentialsRestrictionError
	}

	id := foxid.FOxID(data.Payload)
	user, err := database.GetOne[database.User](ctx.Context(), "id = ?", id.String())
	if err != nil {
		return http.InvalidCredentialsRestrictionError
	}

	if ver, err := token.Verify(data, user.Password); err != nil || !ver {
		return http.InvalidCredentialsRestrictionError
	}

	ctx.Set(headerXUserID, user.ID)

	return ctx.SendStatus(fiber.StatusNoContent)
}
