<template>
  <div class="sso-callback">
    <div class="sso-box">
      <div class="sso-title">{{ $t("sso.title") }}</div>
      <div class="sso-subtitle">{{ $t("sso.subtitle") }}</div>
      <div class="sso-input">
        <el-input
          v-model="passcode"
          :placeholder="$t('sso.passcodePlaceholder')"
          type="password"
          show-password
          @keyup.enter="verify"
        />
      </div>
      <div class="sso-btn" :class="{ 'is-loading': loading }" @click="verify">
        {{ $t("sso.verify") }}
      </div>
      <div class="sso-back" @click="goBack">{{ $t("sso.backToLogin") }}</div>
    </div>
  </div>
</template>

<script>
import Api from "@/apis/api";
import { goToPage, showDanger, showSuccess } from "@/utils";

export default {
  name: "ssoCallback",
  data() {
    return {
      ssoState: "",
      passcode: "",
      loading: false,
    };
  },
  mounted() {
    this.ssoState = this.$route.query.sso_state || "";
    if (!this.ssoState) {
      showDanger(this.$t("sso.invalidState"));
      goToPage("/login");
    }
  },
  methods: {
    verify() {
      if (!this.passcode.trim()) {
        showDanger(this.$t("sso.passcodeRequired"));
        return;
      }
      this.loading = true;
      Api.user.ssoVerify(
        this.ssoState,
        this.passcode,
        ({ data }) => {
          this.loading = false;
          if (data.code === 0) {
            showSuccess(this.$t("sso.loginSuccess"));
            this.$store.commit("setToken", JSON.stringify(data.data));
            this.getUserInfo();
          } else {
            showDanger(data.msg || this.$t("sso.verifyFailed"));
          }
        },
        (err) => {
          this.loading = false;
          showDanger((err.data && err.data.msg) || this.$t("sso.verifyFailed"));
        }
      );
    },
    getUserInfo() {
      Api.user.getUserInfo(({ data }) => {
        if (data.code === 0) {
          this.$store.commit("setUserInfo", data.data);
          goToPage("/home");
        } else {
          showDanger(this.$t("sso.userInfoFailed"));
        }
      });
    },
    goBack() {
      goToPage("/login");
    },
  },
};
</script>

<style lang="scss" scoped>
.sso-callback {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7ff 0%, #eef1ff 100%);
}
.sso-box {
  width: 360px;
  padding: 40px 36px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(87, 120, 255, 0.12);
  text-align: center;
}
.sso-title {
  font-size: 22px;
  font-weight: 600;
  color: #3d4566;
  margin-bottom: 8px;
}
.sso-subtitle {
  font-size: 14px;
  color: #979db1;
  margin-bottom: 24px;
}
.sso-input {
  margin-bottom: 20px;
}
.sso-btn {
  height: 44px;
  line-height: 44px;
  border-radius: 8px;
  background: #5778ff;
  color: #fff;
  font-size: 15px;
  cursor: pointer;
  transition: background 0.2s;
  &.is-loading {
    opacity: 0.7;
    cursor: not-allowed;
  }
  &:hover {
    background: #4a6ae8;
  }
}
.sso-back {
  margin-top: 16px;
  font-size: 13px;
  color: #5778ff;
  cursor: pointer;
}
</style>
